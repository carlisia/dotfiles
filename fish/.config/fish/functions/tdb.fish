# Teleport dev build - compile teleport binaries from source

function tdb --description "Build Teleport binaries from source"
    set -l teleport_repo ~/code/src/github.com/gravitational/teleport

    if not test -d "$teleport_repo"
        set_color red
        echo "Teleport repo not found at $teleport_repo"
        set_color normal
        return 1
    end

    set -l targets

    if test (count $argv) -gt 0
        # Direct mode - use arguments
        for arg in $argv
            switch $arg
                case all
                    set targets build/tsh build/tctl build/teleport build/tbot
                    break
                case tsh tctl teleport tbot
                    set targets $targets build/$arg
                case '*'
                    echo "Unknown target: $arg (valid: all, tsh, tctl, teleport, tbot)"
                    return 1
            end
        end
    else
        # Interactive mode with fzf
        if not type -q fzf
            echo "fzf is not installed"
            return 127
        end

        set -l options "all" "tsh" "tctl" "teleport" "tbot"

        set -l sel (printf '%s\n' $options | fzf \
            --height=40% \
            --reverse \
            --multi \
            --prompt='🔨 Build> ' \
            --header='Select binaries (TAB for multi-select)' \
            --preview='test {} = "all" && echo "Builds: tsh, tctl, teleport, tbot" || echo "Builds: build/{}"')
        or return 130

        if test -z "$sel"
            echo "Nothing selected"
            return 1
        end

        if contains "all" $sel
            set targets build/tsh build/tctl build/teleport build/tbot
        else
            for s in $sel
                set targets $targets build/$s
            end
        end
    end

    set_color yellow
    echo "Building: $targets"
    set_color normal

    make -C "$teleport_repo" $targets

    if test $status -ne 0
        set_color red
        echo "Build failed!"
        set_color normal
        return 1
    end

    set_color green
    echo "Build complete!"
    set_color normal
    echo "Use: dteleport dtsh dtctl dtbot"
end

# Completions for tdb
complete -c tdb -f -a "all tsh tctl teleport tbot" -d "Teleport binary"
