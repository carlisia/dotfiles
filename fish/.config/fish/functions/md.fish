# Deploy to cloud tenant (with zig cross-compiler for Linux)
#
# Usage:
#   md           # interactive source selection
#   md --main    # skip prompt, use main repo

function md --description "Set version and deploy to cloud tenant"
    set -l main_repo $WORK_TELEPORT_REPO
    set -l worktree_dir "$main_repo/.claude/worktrees"
    set -l use_main false

    # Check for --main flag
    if contains -- --main $argv
        set use_main true
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

    # Derive enterprise repo path from selected source
    set -l teleport_repo_e "$teleport_repo/e"

    if not test -d "$teleport_repo"
        echo "❌ Teleport repo not found at $teleport_repo"
        return 1
    end

    # Auto-init e/ submodule in worktrees (git worktrees
    # don't auto-initialize submodules).
    # Uses --reference to reuse local objects from the main
    # repo — avoids a full remote clone.
    if test -d "$teleport_repo_e" -a -z "$(ls -A "$teleport_repo_e" 2>/dev/null)"
        echo "📦 Initializing e/ submodule in worktree..."
        git -C "$teleport_repo" submodule update --init \
            --reference "$main_repo/.git/modules/e" e
        if test $status -ne 0
            echo "❌ Failed to init e/ submodule"
            return 1
        end
    end

    if not test -d "$teleport_repo_e"
        echo "❌ Teleport e/ repo not found at $teleport_repo_e"
        return 1
    end

    echo ""
    echo "📂 Source: $teleport_repo"

    # Check if logged into AWS (using the tc-stage-ecr profile)
    if not aws sts get-caller-identity --profile tc-stage-ecr &>/dev/null
        echo "🔐 Not logged into AWS"
        read -P "   Login now? [y/N] " login_answer
        if test "$login_answer" = "Y" -o "$login_answer" = "y"
            make -C "$teleport_repo_e" deploy-cloud-login || return 1
            echo ""
        else
            echo "❌ Aborting - AWS login required"
            return 1
        end
    end

    read -P "🏠 TENANT> " tenant

    if test -z "$tenant"
        echo "❌ No tenant entered"
        return 1
    end

    read -P "🏷️  BASE_IMAGE_TAG> " ver

    if test -z "$ver"
        echo "❌ No version entered"
        return 1
    end

    echo ""
    echo "🔨 Setting version to $ver..."
    make -C "$teleport_repo" -f version.mk setver VERSION=$ver || return 1

    echo ""
    echo "🚀 Deploying $ver to $tenant (using zig cross-compiler)..."
    env CC="zig cc -target x86_64-linux-gnu" CXX="zig c++ -target x86_64-linux-gnu" make -C "$teleport_repo_e" TENANT=$tenant BASE_IMAGE_TAG=$ver deploy-cloud
end

# Completions for md
complete -c md -l main -d "Use main repo (skip source prompt)"
