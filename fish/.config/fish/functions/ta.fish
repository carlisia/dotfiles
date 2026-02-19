function ta --description 'Terraform apply with auto-refreshed Teleport creds'
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end
    eval "$(dtctl terraform env)"
    or begin; echo "Failed to load Teleport provider creds."; return 1; end
    terraform apply $argv
end
