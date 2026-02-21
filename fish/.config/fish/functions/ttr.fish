function ttr --description 'Reset staging after a discovery test case'
    set -l staging_dir $WORK_TELEPORT_STAGING_DIR

    # Pre-flight: ensure tsh session is valid
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end

    # Refresh Teleport provider creds
    echo "── Refreshing Terraform provider creds ──"
    eval "$(dtctl terraform env)"
    or begin; echo "Failed to load Teleport provider creds."; return 1; end

    # Clear cached role creds so the check exercises the full SSO token path
    command find ~/.aws/cli/cache -maxdepth 1 -name '*.json' -delete 2>/dev/null
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end

    # Step 1: Find and destroy active test case
    echo ""
    echo "── Step 1: Destroy active test case ──"
    set -l tests (find $staging_dir -mindepth 2 -maxdepth 2 -type d -name 'tc*' 2>/dev/null | sort | string replace "$staging_dir/" '')
    set -l active
    for t in $tests
        if test -f "$staging_dir/$t/terraform.tfstate"
            set -a active $t
        end
    end

    if test (count $active) -eq 0
        echo "   No active test cases found, skipping."
    else if test (count $active) -eq 1
        echo "   Destroying: $active[1]"
        terraform -chdir=$staging_dir/$active[1] init -input=false
        terraform -chdir=$staging_dir/$active[1] destroy
        or echo "   ⚠️  Destroy failed for $active[1]"
    else
        set -l selected (printf '%s\n' $active | fzf --prompt="Destroy test> " --header="Select test case to destroy (ESC to skip)")
        if test -n "$selected"
            echo "   Destroying: $selected"
            terraform -chdir=$staging_dir/$selected init -input=false
            terraform -chdir=$staging_dir/$selected destroy
            or echo "   ⚠️  Destroy failed for $selected"
        else
            echo "   Skipped test case destruction."
        end
    end

    # Step 2: Clean up agent and discovery configs
    echo ""
    echo "── Step 2: Clean up agent and discovery configs ──"
    tad

    # Step 3: Restore main staging config
    echo ""
    echo "── Step 3: Restore main staging config ──"
    terraform -chdir=$staging_dir init -input=false >/dev/null
    terraform -chdir=$staging_dir apply
end
