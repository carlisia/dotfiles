function td --description 'Terraform destroy with auto-refreshed Teleport creds'
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end
    eval "$(dtctl terraform env)"
    or begin; echo "Failed to load Teleport provider creds."; return 1; end
    terraform destroy $argv
end
