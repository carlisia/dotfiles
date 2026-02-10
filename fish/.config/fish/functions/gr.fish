# Git rebase workflow: sync branch with master
# master checkout → pull → branch checkout → rebase master → init submodules

function gr --description "Rebase a carlisia/ branch on master"
    # Check we're in a git repo
    if not git rev-parse --git-dir &>/dev/null
        echo "🚫 Not a git repository"
        return 1
    end

    # Pick branch with fzf (only carlisia/ branches)
    if not type -q fzf
        echo "🚫 fzf is not installed"
        return 127
    end

    set -l branches (git branch --list "carlisia/*" | sed 's/^[* ]*//')
    
    if test (count $branches) -eq 0
        echo "🚫 No carlisia/ branches found"
        return 1
    end

    set -l branch (printf '%s\n' $branches | fzf \
        --height=50% \
        --reverse \
        --prompt='🌿 Branch> ' \
        --preview='git log --oneline --color=always -10 {}' \
        --preview-window=right:50%:wrap)
    
    if test -z "$branch"
        echo "❌ No branch selected"
        return 130
    end

    echo "🔄 Syncing $branch with master..."
    echo ""

    # Checkout master
    echo "📍 Checking out master..."
    git checkout master || begin
        echo "🚫 Failed to checkout master"
        return 1
    end

    # Sync submodules (fixes stale references)
    echo "🔗 Syncing submodules..."
    git submodule sync

    # Pull latest
    echo "⬇️  Pulling master..."
    git pull || begin
        echo "🚫 Failed to pull master"
        return 1
    end

    # Checkout target branch
    echo "📍 Checking out $branch..."
    git checkout $branch || begin
        echo "🚫 Failed to checkout $branch"
        return 1
    end

    # Rebase on master
    echo "🔀 Rebasing on master..."
    git rebase master || begin
        echo "🚫 Rebase failed - resolve conflicts and run: git rebase --continue"
        return 1
    end

    # Init submodules
    echo "📦 Initializing submodules..."
    make init-submodules-e || begin
        echo "🚫 make init-submodules-e failed"
        return 1
    end

    echo ""
    echo "✅ $branch is now synced with master!"
    echo ""
    git status -sb
end
