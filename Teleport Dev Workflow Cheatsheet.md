# Teleport Dev Workflow Cheatsheet

All custom shell functions and aliases for working with Teleport.
Source: `dotfiles/fish/` — functions live in `functions/`, aliases in `config.fish`.

> Config note: org-specific values (email, AWS profiles, cluster domain, repo paths) live in `conf.d/work-private.fish` (gitignored). See `work-private.fish.example` for setup.

---

## Quick Reference

| Command             | Purpose                                    | Interactive? |
| ------------------- | ------------------------------------------ | :----------: |
| `tu`                | Switch/create Teleport profile + full auth |  fzf or arg  |
| `tui`               | Show current profile & session status      |      no      |
| `tud`               | Delete a Teleport profile                  |  fzf or arg  |
| `mc`                | Create cloud tenant                        |   prompts    |
| `md`                | Deploy to cloud tenant                     |   prompts    |
| `tdb`               | Build Teleport binaries from source        |  fzf or arg  |
| `tad`               | Remove Teleport agent from EC2 via SSM     |   prompts    |
| `ec2d`              | Clean agent + terminate EC2 instance       |  fzf or arg  |
| `ec2c`              | Create staging EC2 instance via Terraform  |      no      |
| `gr`                | Rebase branch on master + init submodules  |     fzf      |
| `te`                | Load short-lived Terraform provider creds  |      no      |
| `ta` `tp` `ti` `td` | Terraform apply/plan/init/destroy          |      no      |
| `dversions`         | Show all dev + release binary versions     |      no      |

---

## Profile Management

### `tu [profile-name]` — Switch or Create Profile

Full auth workflow: sets `TELEPORT_HOME`, runs AWS deploy-cloud-login, AWS SSO, `tsh login`, and updates `locals.tf`.

```bash
tu carlisia-disc     # direct — switch to (or create) profile
tu                   # interactive — fzf picker with "+ Create new"
```

**What it does (4 steps):**

1. Sets `AWS_PROFILE` to ECR profile, runs `make deploy-cloud-login` in teleport/e
2. Restores `AWS_PROFILE` to default, runs `aws sso login`
3. Runs `tsh login --proxy=<profile>.<cluster-domain>:443`
4. Updates `teleport_proxy_public_addr` in staging `locals.tf` via sed

**Side effects:**

- Sets `TELEPORT_HOME` globally to `~/tsh_profiles/<name>`
- Toggles `AWS_PROFILE` between ECR and default profiles
- Modifies `locals.tf` in the teleport-dev-infra staging dir
- Creates `envtest.mk` stub if missing (harmless — needed by e/Makefile)

**Profiles stored in:** `~/tsh_profiles/<name>/`

---

### `tui` — Show Profile Status

Read-only. Shows current `TELEPORT_HOME` and runs `tsh status`.

```bash
tui
```

**Side effects:** None.

---

### `tud [profile-name]` — Delete Profile

Moves profile directory to trash (not `rm`). Clears `TELEPORT_HOME` if it pointed to the deleted profile.

```bash
tud carlisia-disc    # direct
tud                  # interactive — fzf picker
```

**Side effects:**

- Trashes `~/tsh_profiles/<name>/`
- Unsets `TELEPORT_HOME` if it matched

---

## Cloud Tenant Operations

### `mc` — Create Cloud Tenant

Prompts for tenant name and release version, then runs `make create-cloud` in teleport/e.

```bash
mc
# prompts: TENANT> carlisia-disc
# prompts: RELEASE> 17.1.0
```

**Side effects:** Creates a cloud tenant in staging.

---

### `md` — Deploy to Cloud Tenant

Checks AWS login, prompts for tenant + version, cross-compiles with zig, deploys.

```bash
md
# prompts: TENANT> carlisia-disc
# prompts: BASE_IMAGE_TAG> 17.1.0
```

**Side effects:**

- Runs `make setver` to update version files
- Cross-compiles for linux/amd64 using zig
- Deploys to the specified cloud tenant

---

## Building

### `tdb [target...]` — Build Teleport From Source

Compiles binaries in `~/code/src/github.com/gravitational/teleport/build/`.

```bash
tdb tsh              # build just tsh
tdb tsh tctl         # build multiple
tdb all              # build everything
tdb                  # interactive — fzf multi-select (TAB to pick)
```

**Available targets:** `tsh`, `tctl`, `teleport`, `tbot`, `all`

**Side effects:** Writes to `teleport/build/` directory.

**Dev binary aliases** (use after building):

| Alias       | Points to                 |
| ----------- | ------------------------- |
| `dtsh`      | `teleport/build/tsh`      |
| `dtctl`     | `teleport/build/tctl`     |
| `dteleport` | `teleport/build/teleport` |
| `dtbot`     | `teleport/build/tbot`     |

### `dversions` — Show Binary Versions

Prints version info for all dev builds and release installations side by side.

```bash
dversions
```

**Side effects:** None.

---

## EC2 Cleanup

### `tad [instance-id]` — Teleport Agent Delete

Removes Teleport agent from an EC2 instance via AWS SSM.

```bash
tad i-07a65cb983d6bd40f
tad --region us-east-1 i-07a65cb983d6bd40f
tad                              # prompts for instance ID
```

**What it does:**

1. Sends SSM command to stop + disable teleport service
2. Removes `/etc/teleport.yaml`, `/var/lib/teleport/`, `/etc/teleport-update.yaml`, `/etc/teleport.d/`
3. Sends verification command to confirm cleanup

**Side effects:**

- **Destructive on the EC2 instance** — removes all Teleport state
- Has confirmation prompt before executing
- Default region: `us-west-2`

**After cleanup:** Discovery will re-enroll the instance with the correct cluster.

---

### `ec2d [instance-id]` — Destroy EC2 Instance

Runs `tad` to clean the Teleport agent and remove discovery configs, then terminates the EC2 instance. Use this when you want a completely fresh instance for re-enrollment testing.

```bash
ec2d i-0eb21f1663a769f4e
ec2d --region us-east-1 i-0eb21f1663a769f4e
ec2d                     # interactive — fzf picker
```

**What it does:**

1. Runs `tad` on the selected instance (cleans agent + removes discovery configs)
2. Terminates the EC2 instance via `aws ec2 terminate-instances`

**Side effects:**

- **Destructive** — removes all Teleport state AND terminates the instance
- Has confirmation prompt before executing
- Default region: `us-west-2`

**After destroy:** Run `ec2c` to create a fresh EC2 instance.

---

### `ec2c` — Create Staging EC2 Instance

Runs `terraform apply` on the parent staging directory to create (or restore) the EC2 instance, security group, SSH key, and discovery integration.

```bash
tec2
```

**What it does:**

1. Refreshes Teleport provider creds and AWS SSO session
2. Runs `terraform init` + `terraform apply` on the staging directory
3. Shows the new instance's public IP

**Side effects:**

- Creates or updates AWS infrastructure (EC2, security group, SSH key, discovery integration)
- Prompts for Terraform apply confirmation

**After creation:** Run `ttc` to apply a test case.

---

## Git Workflow

### `gr` — Rebase Branch on Master

Syncs a `carlisia/*` branch with master, including submodule init.

```bash
gr                   # fzf picks from carlisia/* branches
```

**Steps:** checkout master → sync submodules → pull → checkout branch → rebase → `make init-submodules-e`

**Side effects:**

- Changes your current git branch (twice)
- Pulls latest master
- Rewrites branch history (rebase)

**Tip:** stash first with `s` (alias for `git add . && git stash`).

---

## Terraform Aliases

| Alias | Expands to                     | Notes                                    |
| ----- | ------------------------------ | ---------------------------------------- |
| `ti`  | `terraform init`               | Run first in a new workspace             |
| `tp`  | `terraform plan`               | Preview changes                          |
| `ta`  | `terraform apply`              | Apply changes                            |
| `td`  | `terraform destroy`            | Tear down resources                      |
| `te`  | `eval "$(tctl terraform env)"` | Load short-lived Teleport provider creds |

**Typical flow after `tu`:**

```bash
cd ~/code/.../teleport-dev-infra/aws/staging
te          # get creds (short-lived, re-run if expired)
ti          # init
tp          # plan — review changes
ta          # apply
```

---

## Typical Full Workflow

```text
1. tu carlisia-disc       # auth into profile (4-step flow)
2. cd into staging dir    # printed by tu at the end
3. te                     # get Terraform provider creds
4. ti && tp && ta         # init, plan, apply infra
5. tdb tsh                # build dev binary if needed
6. dtsh ...               # use dev binary
7. tad i-xxx              # clean up EC2 if re-enrolling
8. tud carlisia-disc      # delete profile when done
```

**Fresh instance for re-enrollment testing:**

```text
1. ec2d                   # clean agent + terminate instance (fzf picker)
2. ec2c                   # create fresh EC2 instance
3. ttc                    # apply a test case
```
