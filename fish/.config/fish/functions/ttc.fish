function ttc --description 'Prep and run a staging discovery test case'
    set -l staging_dir $WORK_TELEPORT_STAGING_DIR

    # Pre-flight: ensure tsh session is valid
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end

    # Refresh Teleport provider creds (short-lived, always get fresh ones)
    echo "── Refreshing Terraform provider creds ──"
    eval "$(dtctl terraform env)"
    or begin
        echo "Failed to load Teleport provider creds. Run 'te' manually."
        return 1
    end

    # Clear cached role creds so the check exercises the full SSO token path
    command find ~/.aws/cli/cache -maxdepth 1 -name '*.json' -delete 2>/dev/null
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end

    # Step 1: Destroy main discovery config (keeps integration, IAM role, token intact)
    echo "── Step 1: Destroying main staging discovery config ──"
    terraform -chdir=$staging_dir init -input=false >/dev/null
    terraform -chdir=$staging_dir destroy -target='module.aws_discovery.teleport_discovery_config.aws[0]'
    or return 1

    # Step 2: Clean up agent, nodes, and discovery configs
    echo ""
    echo "── Step 2: Clean up agent, nodes + discovery configs ──"
    tad --yes
    or return 1

    # Step 3: Select and apply test case
    echo ""
    echo "── Step 3: Select test case to apply ──"
    set -l tests (find $staging_dir -mindepth 2 -maxdepth 2 -type d -name 'tc*' 2>/dev/null | sort | string replace "$staging_dir/" '')

    if test (count $tests) -eq 0
        echo "No test directories found."
        return 1
    end

    set -l selected_test (printf '%s\n' $tests | fzf --prompt="Apply test> " --header="Select test case to create")
    if test -n "$selected_test"
        echo "Applying test: $selected_test"

        set -l extra_vars
        read -P "🔧 Use custom binary from S3? [y/N] " use_custom
        if test "$use_custom" = "y" -o "$use_custom" = "Y"
            read -P "🔨 Rebuild + upload first? [y/N] " rebuild
            if test "$rebuild" = "y" -o "$rebuild" = "Y"
                mdbin; or return 1
            end
            set extra_vars -var use_custom_binary=true
        end

        terraform -chdir=$staging_dir/$selected_test init -input=false
        terraform -chdir=$staging_dir/$selected_test apply $extra_vars
    else
        echo "No test selected."
    end
end
