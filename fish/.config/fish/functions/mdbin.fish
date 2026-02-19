# Deploy a custom teleport binary to an EC2 instance and run
# `teleport install autodiscover-node` directly, bypassing the CDN
# installer flow (teleport-update re-downloads from CDN, overwriting
# any binary you replace on disk).
#
# Requires: WORK_S3_BUCKET, WORK_PROXY_ADDR, WORK_TOKEN_NAME,
# and TELEPORT_USER set in conf.d/work-private.fish.
#
# Usage:
#   mdbin                       # prompts for instance ID
#   mdbin i-041eb85bba1e9e581   # pass instance ID directly

function mdbin --description "Deploy custom teleport binary to EC2 and run autodiscover-node"
    set -l repo $WORK_TELEPORT_REPO
    set -l bucket $WORK_S3_BUCKET
    set -l s3key "teleport-custom"
    set -l bin /tmp/teleport-custom
    set -l remote_bin /tmp/teleport-custom
    set -l region "us-west-2"
    set -l proxy_addr $WORK_PROXY_ADDR
    set -l token_name $WORK_TOKEN_NAME
    set -l instance_id $argv[1]

    # Refresh AWS SSO session if expired
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login; or begin; echo "AWS SSO login failed."; return 1; end
    end

    # If no instance ID provided, list tagged instances via fzf
    if test -z "$instance_id"
        echo "🔍 Fetching your EC2 instances in $region..."

        set -l ec2_lines (aws ec2 describe-instances --region $region --filters "Name=tag:teleport.dev/creator,Values=$TELEPORT_USER" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].[InstanceId, PrivateIpAddress, Tags[?Key=='Name']|[0].Value]" --output text 2>&1)

        if test $status -ne 0
            echo "❌ Failed to query EC2 instances: $ec2_lines"
            return 1
        end

        if test -z "$ec2_lines"
            echo "   No running instances found."
            return 0
        end

        set -l lines
        for row in $ec2_lines
            set -l fields (string split \t -- $row)
            set -l id $fields[1]
            set -l ip $fields[2]
            set -l name $fields[3]
            test -z "$ip" -o "$ip" = "None"; and set ip "no-ip"
            test -z "$name" -o "$name" = "None"; and set name "unnamed"
            set -a lines (printf "%-22s │ %-30s │ %s" "$id" "$name" "$ip")
        end

        if test (count $lines) -eq 0
            echo "   No instances found."
            return 0
        end

        set -l header (printf "%-22s │ %-30s │ %s" "INSTANCE ID" "NAME" "IP")
        set -l selection (printf '%s\n' $lines | fzf --header="$header" --height=40% --reverse --prompt="🎯 Target instance> ")

        if test -z "$selection"
            echo "   No instance selected."
            return 0
        end

        set instance_id (string split "│" -- $selection)[1]
        set instance_id (string trim -- $instance_id)
    end

    echo ""
    echo "🔨 Building teleport for linux/amd64..."
    env CC="zig cc -target x86_64-linux-gnu" CXX="zig c++ -target x86_64-linux-gnu" GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -C $repo -buildvcs=false -o $bin ./tool/teleport; or return 1

    echo ""
    echo "☁️  Uploading to s3://$bucket/$s3key..."
    aws s3 cp $bin s3://$bucket/$s3key; or return 1

    echo ""
    echo "🔗 Generating pre-signed URL..."
    set -l presigned (aws s3 presign s3://$bucket/$s3key --expires-in 300 --region $region); or return 1

    echo "🚀 Deploying to $instance_id and running autodiscover-node..."
    # Build the remote command and use python to safely JSON-encode it (pre-signed URLs contain & and = that break shell quoting)
    set -l remote_cmd "set -xe; curl -sfSL -o $remote_bin '$presigned' && chmod +x $remote_bin && echo --- custom binary version --- && $remote_bin version && echo --- running autodiscover-node --- && $remote_bin install autodiscover-node --public-proxy-addr=$proxy_addr --teleport-package=teleport-ent --repo-channel=stable/cloud --auto-upgrade=true $token_name"
    set -l param_file (mktemp /tmp/mdbin-params.XXXXXX)
    python3 -c "import json,sys; print(json.dumps({'commands':[sys.argv[1]]}))" "$remote_cmd" > $param_file

    set -l cmd_id (aws ssm send-command --instance-ids $instance_id --region $region --document-name AWS-RunShellScript --parameters file://$param_file --query Command.CommandId --output text); or begin; command rm -f $param_file; return 1; end
    command rm -f $param_file

    echo "   Command: $cmd_id"
    echo "   Waiting..."
    sleep 30

    aws ssm get-command-invocation --command-id $cmd_id --instance-id $instance_id --region $region --query "[Status,StandardOutputContent,StandardErrorContent]" --output text

    echo ""
    echo "✅ Done."
end
