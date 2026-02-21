# Teleport Dev Workflow Cheatsheet

All custom shell functions and aliases for working with Teleport.
Source: `dotfiles/fish/` — functions live in `functions/`, aliases in `config.fish`.

> Config note: org-specific values (email, AWS profiles, cluster domain, repo paths) live in `conf.d/work-private.fish` (gitignored). See `work-private.fish.example` for setup.

---

## Quick reference

| Command        | Purpose                                      | Requires | Interactive? |
| -------------- | -------------------------------------------- | :------: | :----------: |
| `tu`           | Switch/create Teleport profile + full auth   |    —     |  fzf or arg  |
| `tui`          | Show current profile & session status        |    —     |      no      |
| `tud`          | Delete a Teleport profile                    |    —     |  fzf or arg  |
| `mc`           | Create cloud tenant                          |   AWS    |   prompts    |
| `md`           | Deploy to cloud tenant                       |   AWS    |   prompts    |
| `mdbin`        | Build custom binary + upload to S3            |   AWS    |      no      |
| `tdb`          | Build Teleport binaries from source          |    —     |  fzf or arg  |
| `tad`          | Remove Teleport agent from EC2 + del configs |   `tu`   |  fzf or arg  |
| `ec2d`         | Clean agent + terminate EC2 instance         |   `tu`   |  fzf or arg  |
| `ec2c`         | Create staging EC2 instance via Terraform    |   `tu`   |      no      |
| `ttc`          | Prep staging + run a discovery test case     |   `tu`   | fzf + prompt |
| `ttr`          | Reset staging after a test case              |   `tu`   |     fzf      |
| `gr`           | Rebase branch on master + init submodules    |    —     |     fzf      |
| `te`           | Load short-lived Terraform provider creds    |   `tu`   |      no      |
| `ta` `tp` `td` | Terraform apply/plan/destroy (auto-refresh)  |   `tu`   |      no      |
| `ti`           | Terraform init                               |    —     |      no      |
| `dversions`    | Show all dev + release binary versions       |    —     |      no      |

**Requires column:** `tu` = needs an active tsh session (run `tu` first). AWS = needs AWS creds (auto-refreshes, offers login if expired). — = no auth needed.

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
3. Runs `tsh login --proxy=<profile>.<cluster-domain>:443`, then sets kube namespace to match the tenant
4. Updates `teleport_proxy_public_addr` in staging `locals.tf` via sed

**Side effects:**

- Sets `TELEPORT_HOME` globally to `~/tsh_profiles/<name>`
- Sets `TENANT` globally to the profile name
- Toggles `AWS_PROFILE` between ECR and default profiles
- Updates kube namespace to `<cluster-domain>-<profile-name>`
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

Checks AWS creds (offers `deploy-cloud-login` if expired), prompts for tenant name and release version, then runs `make create-cloud` in teleport/e.

```bash
mc
# prompts: TENANT> carlisia-disc
# prompts: RELEASE> 17.1.0
```

**Side effects:** Creates a cloud tenant in staging. Does not require a tsh dev session — uses platform auth (`~/.tsh_platform`) via the `tc` tool.

---

### `md` — Deploy to Cloud Tenant

Checks AWS login (offers `deploy-cloud-login` if expired), prompts for tenant + version, cross-compiles with zig, deploys.

```bash
md
# prompts: TENANT> carlisia-disc
# prompts: BASE_IMAGE_TAG> 17.1.0
```

**Side effects:**

- Runs `make setver` to update version files
- Cross-compiles for linux/amd64 using zig
- Deploys to the specified cloud tenant
- Does not require a tsh dev session — uses platform auth via `deploy-cloud`

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

## EC2 operations

### `tad [instance-id]` — Teleport Agent Delete

Two-phase cleanup: removes Teleport agent from an EC2 instance via SSM, then offers to delete discovery configs from the cluster.

```bash
tad i-07a65cb983d6bd40f
tad --region us-east-1 i-07a65cb983d6bd40f
tad                              # interactive — fzf instance picker
```

**What it does:**

Phase 1 — EC2 agent cleanup (optional, ESC to skip):

1. Lists your EC2 instances via fzf (filtered by `teleport.dev/creator` tag, shows SSM status)
2. Sends SSM command to stop + disable teleport service
3. Removes `/etc/teleport.yaml`, `/var/lib/teleport/`, `/etc/teleport-update.yaml`, `/etc/teleport.d/`
4. Sends verification command to confirm cleanup

Phase 2 — Discovery config cleanup (always offered):

5. Lists discovery configs via `dtctl get discovery_config`
6. Prompts to delete selected config

**Side effects:**

- **Destructive on the EC2 instance** — removes all Teleport state
- Deletes selected discovery config from the cluster
- Has confirmation prompts before each phase
- Instance selection is optional — ESC to skip to discovery config cleanup only
- Default region: `us-west-2`

**After cleanup:** Discovery will re-enroll the instance with the correct cluster.

---

### `ec2d [instance-id]` — Destroy EC2 Instance

Use this when you want to decomission an instance.

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
ec2c
```

**What it does:**

1. Refreshes Teleport provider creds and AWS SSO session
2. Runs `terraform init` + `terraform apply` on the staging directory
3. Shows the new instance's public IP

**Side effects:**

- Creates or updates AWS infrastructure (EC2, security group, SSH key, discovery integration)
- Prompts for Terraform apply confirmation

**After creation:** Run `ttc` to apply (create) a test case.

---

### `mdbin` — Build Custom Binary and Upload to S3

Cross-compiles a `teleport` binary for linux/amd64 using zig and uploads it to S3. The binary is used by the `custom-s3-installer` when `ttc` is run with the custom binary option.

```bash
mdbin
```

**What it does:**

1. Checks AWS creds (auto-refreshes via `aws sso login` if expired)
2. Cross-compiles `teleport` for linux/amd64 using zig
3. Uploads binary to S3 (`$WORK_S3_BUCKET/teleport-custom`)

**Side effects:**

- Writes a temporary binary to `/tmp/teleport-custom`
- Uploads to S3 (overwrites `teleport-custom` key each time)
- Does not require a tsh dev session — AWS-only

**Required env vars (from `work-private.fish`):** `WORK_S3_BUCKET`, `WORK_TELEPORT_REPO`

**Note:** You don't usually call `mdbin` directly. `ttc` calls it automatically when you choose to use a custom binary.

---

## Discovery test cycle

### `ttc` — Teleport Test Case - Create

Preps the staging environment and runs a discovery test case. Automates the multi-step process required to test a specific discovery failure scenario. Optionally builds and deploys a custom binary from your branch.

```bash
ttc     # interactive — walks through all steps
```

**What it does (4 steps):**

1. Destroys the main staging discovery config (`terraform destroy -target`), keeping the integration, IAM role, and provision token intact
2. Removes the enrolled node from the cluster (auto-selects if only one, fzf if multiple)
3. Removes the teleport agent from the EC2 instance via SSM (`tad`) — stops service, deletes config and identity certs
4. Prompts (via fzf) to select a test case from `aws/staging/<issue>/<test>`
5. Asks whether to use a custom binary from S3:
   - **Yes:** calls `mdbin` (build + upload), then applies with `-var use_custom_binary=true` — discovery uses `custom-s3-installer` which downloads your binary from S3
   - **No:** applies normally — discovery uses `default-installer` which installs the official CDN binary

**Why all three removal steps are needed:**

- Destroying the discovery config stops scanning, but the node stays registered.
- Removing the node (`tctl rm`) clears the cluster-side registration, but the teleport agent on the instance still holds valid identity certs from the previous join and will immediately re-register itself.
- Removing the agent via SSM (`tad`) wipes the certs and config, making the instance truly unenrolled so discovery treats it as a fresh target.

**Side effects:**

- Destroys one Teleport `discovery_config` resource (re-created by `ta` in staging dir)
- Removes one node from the Teleport cluster
- Wipes Teleport agent state from the EC2 instance (service, config, data dir)
- Deletes selected discovery configs from the cluster (via `tad` phase 2)
- Applies Terraform in the selected test directory
- If custom binary: builds and uploads binary to S3 via `mdbin`
- Auto-refreshes Teleport provider creds and AWS SSO before starting

**After testing, to restore:** Run `ttr` to destroy the test case, clean up the agent, and restore the main staging config.

---

### `ttr` — Teleport Test Case - Reset

Resets the staging environment after a discovery test case. The inverse of `ttc`.

```bash
ttr     # interactive — walks through all steps
```

**What it does (3 steps):**

1. Finds active test cases (tc\* dirs with terraform state) and destroys the selected one
2. Cleans up the agent and discovery configs via `tad` (instance optional, discovery config deletion always offered)
3. Applies the main staging config to restore the valid discovery config, integration, and token

**When to use:** After a test case has produced the expected result (e.g., a join failure user task appeared) and you want to return to the happy-path staging config.

**Side effects:**

- Destroys Terraform resources in the selected test directory
- Wipes Teleport agent state from the EC2 instance (via `tad`)
- Deletes discovery configs from the cluster (via `tad`)
- Re-applies the main staging Terraform config
- Auto-refreshes Teleport provider creds and AWS SSO before starting

---

### `ttc` + `ttr` workflow

**With official binary (CDN):**

```text
1. ttc                # tear down, prep, select test, answer N to custom binary
2. (verify result)    # check UI for expected user task / behavior
3. ttr                # destroy test case, clean up, restore main config
```

**With custom binary (your branch):**

```text
1. ttc                # tear down, prep, select test, answer Y to custom binary
                      # (auto-builds + uploads to S3 via mdbin)
2. (verify result)    # check UI for expected user task / behavior
3. ttr                # destroy test case, clean up, restore main config
```

**Iterating on code changes:**

```text
1. (edit code)
2. ttc                # answer Y — rebuilds + re-uploads automatically
3. (verify result)
4. ttr
```

---

## Git workflow

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

## Terraform commands

Note: favor the `ttc` + `ttr` workflow described above.

| Command | Type     | Notes                                                 |
| ------- | -------- | ----------------------------------------------------- |
| `ti`    | alias    | `terraform init` — run first in a new workspace       |
| `tp`    | function | Session check + cred refresh + `terraform plan`       |
| `ta`    | function | Session check + cred refresh + `terraform apply`      |
| `td`    | function | Session check + cred refresh + `terraform destroy`    |
| `te`    | alias    | `eval "$(dtctl terraform env)"` — manual cred refresh |

`ta`, `tp`, `td` auto-refresh Teleport provider creds before running. No need to run `te` first — creds are always fresh. `te` is still available for manual refresh (e.g., before `ti` or raw `terraform` commands).

**Typical flow after `tu`:**

```bash
cd ~/code/.../teleport-dev-infra/aws/staging
ti          # init
tp          # plan — review changes
ta          # apply (creds auto-refresh)
```

---

## Typical full workflow

```text
1. tu carlisia-disc       # auth into profile (4-step flow)
2. cd into staging dir    # printed by tu at the end
3. ti && tp && ta         # init, plan, apply infra (creds auto-refresh)
4. tdb tsh                # build dev binary if needed
5. dtsh ...               # use dev binary
6. tad                    # clean up EC2 + discovery configs if re-enrolling
7. tud carlisia-disc      # delete profile when done
```

**Discovery test cycle:**

```text
1. tu carlisia-disc       # auth
2. ttc                    # tear down, prep, apply test case
3. (verify in UI)         # check for expected user task / behavior
4. ttr                    # reset — destroy test, clean up, restore main config
```

**Fresh instance for re-enrollment testing:**

```text
1. ec2d                   # clean agent + terminate instance (fzf picker)
2. ec2c                   # create fresh EC2 instance
3. ttc                    # apply a test case
```

**Deploy custom binary (standalone, no tsh session needed):**

```text
1. mdbin                  # build + upload to S3 only
2. ttc                    # answer Y to use custom binary
```
