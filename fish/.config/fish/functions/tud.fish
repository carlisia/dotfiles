# Delete Teleport profile

function tud --description "Delete a TELEPORT_HOME profile"
    set -l base ~/tsh_profiles

    if not test -d "$base"
        echo "🚫 No profiles directory"
        return 1
    end

    set -l target

    if test (count $argv) -gt 0
        # Direct mode
        set target "$base/$argv[1]"
        if not test -d "$target"
            echo "🚫 Profile '$argv[1]' doesn't exist"
            return 1
        end
    else
        # Interactive mode with fzf
        if not type -q fzf
            echo "🚫 fzf is not installed"
            return 127
        end

        set -l names
        for d in $base/*
            if test -d "$d"
                set names $names (basename "$d")
            end
        end

        if test (count $names) -eq 0
            echo "🚫 No profiles to delete"
            return 1
        end

        set -l sel (printf '%s\n' $names | fzf \
            --height=40% \
            --reverse \
            --prompt='🗑️  Delete profile> ' \
            --preview="test -f $base/{}/current-profile && cat $base/{}/current-profile || echo 'No active session'" \
            --preview-window=up:3:wrap)
        or return 130

        set target "$base/$sel"
    end

    set -l name (basename "$target")
    
    # Confirm deletion
    read -P "🗑️  Delete profile '$name'? [y/N] " answer
    if test "$answer" = "Y" -o "$answer" = "y"
        if trash "$target"
            echo "✅ Deleted profile: $name"
        else
            echo "🚫 Failed to delete profile: $name"
            return 1
        end
        
        # Clear TELEPORT_HOME if it was pointing to deleted profile
        if test "$TELEPORT_HOME" = "$target"
            set -e TELEPORT_HOME
            echo "   (TELEPORT_HOME cleared)"
        end
    else
        echo "❌ Cancelled"
    end
end

# Completions for tud
complete -c tud -f -a "(for d in ~/tsh_profiles/*; test -d \$d && basename \$d; end)" -d "Teleport profile"
