function ta --description 'Terraform apply with auto-refreshed Teleport creds'
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end
    command find ~/.aws/cli/cache -maxdepth 1 -name '*.json' -delete 2>/dev/null
    if not aws sts get-caller-identity &>/dev/null
        echo "🔐 AWS SSO session expired, logging in..."
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end
    eval "$(dtctl terraform env)"
    or begin; echo "Failed to load Teleport provider creds."; return 1; end
    terraform apply $argv
end
