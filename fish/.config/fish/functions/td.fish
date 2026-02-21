function td --description 'Terraform destroy with auto-refreshed Teleport creds'
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end
    # Clear cached role creds so the check exercises the full SSO token
    # path — otherwise cached short-lived creds mask an expired SSO token
    # and Terraform fails even though `aws sts` succeeds.
    command find ~/.aws/cli/cache -maxdepth 1 -name '*.json' -delete 2>/dev/null
    if not aws sts get-caller-identity &>/dev/null
        echo "🔐 AWS SSO session expired, logging in..."
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end
    eval "$(dtctl terraform env)"
    or begin; echo "Failed to load Teleport provider creds."; return 1; end

    # In staging root with no explicit target, scope to the discovery module
    # to avoid nuking EC2, IAM, OIDC, etc. Use `terraform destroy` directly
    # for a full teardown.
    set -l staging_dir $WORK_TELEPORT_STAGING_DIR
    set -l in_staging_root false
    if test -n "$staging_dir" -a (pwd) = "$staging_dir"
        set in_staging_root true
    end

    if test "$in_staging_root" = true
        # Check if user passed an explicit -target
        set -l has_target false
        for arg in $argv
            string match -q -- '-target*' "$arg"; and set has_target true
        end

        if test "$has_target" = false
            echo "── Destroying discovery module (run 'terraform destroy' for full teardown) ──"
            terraform destroy -target='module.aws_discovery' $argv
        else
            terraform destroy $argv
        end
        or return 1

        echo ""
        echo "── Cleaning up Teleport agent, nodes + discovery configs ──"
        tad
    else
        terraform destroy $argv
    end
end
