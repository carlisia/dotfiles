# Build a custom teleport binary for linux/amd64 and upload to S3.
# Used by ttc to deploy via the custom-s3-installer discovery flow.
#
# Requires: WORK_S3_BUCKET and WORK_TELEPORT_REPO
# set in conf.d/work-private.fish.
#
# Usage:
#   mdbin           # interactive source selection
#   mdbin --main    # skip prompt, use main repo

function mdbin --description "Build custom teleport binary and upload to S3"
    set -l bucket $WORK_S3_BUCKET
    set -l s3key "teleport-custom"
    set -l bin /tmp/teleport-custom
    set -l main_repo $WORK_TELEPORT_REPO
    set -l worktree_dir "$main_repo/.claude/worktrees"

    # Allow --main flag to skip the prompt
    if contains -- --main $argv
        set repo $main_repo
    else
        # Build menu: main repo + any worktrees
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
            set repo $main_repo
        else
            echo "Select build source:"
            for i in (seq (count $choices))
                echo "  $i) $choices[$i]"
            end
            read -P "Choice [1]: " pick
            test -z "$pick"; and set pick 1

            if test "$pick" -ge 1 -a "$pick" -le (count $paths) 2>/dev/null
                set repo $paths[$pick]
            else
                echo "Invalid selection."; return 1
            end
        end
    end

    echo ""
    echo "📂 Source: $repo"

    # Refresh AWS SSO session if expired
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login; or begin; echo "AWS SSO login failed."; return 1; end
    end

    echo ""
    echo "🔨 Building teleport for linux/amd64..."
    env CC="$HOME/.local/bin/zig-cc-linux" \
        CXX="$HOME/.local/bin/zig-cxx-linux" \
        GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
        go build -C $repo -buildvcs=false \
        -o $bin ./tool/teleport; or return 1

    echo ""
    echo "☁️  Uploading to s3://$bucket/$s3key..."
    aws s3 cp $bin s3://$bucket/$s3key; or return 1

    echo ""
    echo "✅ Binary built and uploaded to S3."
end
