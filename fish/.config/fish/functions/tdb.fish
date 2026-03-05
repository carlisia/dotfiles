# Teleport dev build - compile teleport binaries from source
#
# Usage:
#   tdb              # interactive source + binary selection
#   tdb teleport     # interactive source, build teleport
#   tdb --main all   # skip source prompt, build all from main repo

function tdb --description "Build Teleport binaries from source"
    set -l main_repo $WORK_TELEPORT_REPO
    set -l worktree_dir "$main_repo/.claude/worktrees"
    set -l use_main false

    # Check for --main flag and strip it from argv
    set -l build_args
    for arg in $argv
        if test "$arg" = --main
            set use_main true
        else
            set -a build_args $arg
        end
    end

    # Select build source
    if test "$use_main" = true
        set teleport_repo $main_repo
    else
        set -l choices "main repo ($main_repo)"
        set -l paths $main_repo

        if test -d "$worktree_dir"
            for wt in $worktree_dir/*/
                set -l name (basename $wt)
                set -a choices "worktree: $name"
                set -a paths $wt
            end
        end

        if test (count $choices) -eq 1
            set teleport_repo $main_repo
        else
            echo "Select build source:"
            for i in (seq (count $choices))
                echo "  $i) $choices[$i]"
            end
            read -P "Choice [1]: " pick
            test -z "$pick"; and set pick 1

            if test "$pick" -ge 1 -a "$pick" -le (count $paths) 2>/dev/null
                set teleport_repo $paths[$pick]
            else
                echo "Invalid selection."; return 1
            end
        end
    end

    if not test -d "$teleport_repo"
        set_color red
        echo "Teleport repo not found at $teleport_repo"
        set_color normal
        return 1
    end

    echo ""
    echo "📂 Source: $teleport_repo"

    set -l targets

    if test (count $build_args) -gt 0
        # Direct mode - use arguments
        for arg in $build_args
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
complete -c tdb -l main -d "Use main repo (skip source prompt)"
