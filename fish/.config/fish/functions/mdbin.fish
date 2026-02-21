# Build a custom teleport binary for linux/amd64 and upload to S3.
# Used by ttc to deploy via the custom-s3-installer discovery flow.
#
# Requires: WORK_S3_BUCKET and WORK_TELEPORT_REPO
# set in conf.d/work-private.fish.
#
# Usage:
#   mdbin

function mdbin --description "Build custom teleport binary and upload to S3"
    set -l repo $WORK_TELEPORT_REPO
    set -l bucket $WORK_S3_BUCKET
    set -l s3key "teleport-custom"
    set -l bin /tmp/teleport-custom

    # Refresh AWS SSO session if expired
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login; or begin; echo "AWS SSO login failed."; return 1; end
    end

    echo ""
    echo "🔨 Building teleport for linux/amd64..."
    env CC="zig cc -target x86_64-linux-gnu" \
        CXX="zig c++ -target x86_64-linux-gnu" \
        GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
        go build -C $repo -buildvcs=false \
        -o $bin ./tool/teleport; or return 1

    echo ""
    echo "☁️  Uploading to s3://$bucket/$s3key..."
    aws s3 cp $bin s3://$bucket/$s3key; or return 1

    echo ""
    echo "✅ Binary built and uploaded to S3."
end
