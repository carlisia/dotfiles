# Clean up Teleport agent from EC2 instance via SSM
# Use this when an EC2 instance needs to be re-enrolled with a different cluster

function tad --description "Remove Teleport agent config from EC2 instance via SSM"
    set -l region "us-west-2"
    set -l instance_id ""

    # Parse arguments
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --region -r
                set i (math $i + 1)
                set region $argv[$i]
            case '*'
                set instance_id $argv[$i]
        end
        set i (math $i + 1)
    end

    # If no instance ID provided, list tagged instances via fzf
    if test -z "$instance_id"
        echo "🔍 Fetching your EC2 instances in $region..."

        # Query EC2 instances filtered by creator tag, output as flat TSV to avoid JSON/fish splitting issues
        set -l ec2_lines (aws ec2 describe-instances \
            --region $region \
            --filters \
                "Name=tag:teleport.dev/creator,Values=carlisia.campos@goteleport.com" \
                "Name=instance-state-name,Values=running,stopped" \
            --query "Reservations[].Instances[].[InstanceId, State.Name, PrivateIpAddress, Tags[?Key=='Name']|[0].Value]" \
            --output text 2>&1)

        if test $status -ne 0
            echo "❌ Failed to query EC2 instances: $ec2_lines"
            return 1
        end

        if test -z "$ec2_lines"
            echo "❌ No instances found with your creator tag in $region"
            return 1
        end

        # Get SSM status for all instances in one call (flat TSV)
        set -l ssm_lines (aws ssm describe-instance-information \
            --region $region \
            --query "InstanceInformationList[].[InstanceId, PingStatus]" \
            --output text 2>&1)

        # Build fzf-friendly list from the TSV output
        set -l lines
        for row in $ec2_lines
            set -l fields (string split \t -- $row)
            set -l id $fields[1]
            set -l state $fields[2]
            set -l ip $fields[3]
            set -l name $fields[4]

            # Default values for missing fields
            test -z "$ip" -o "$ip" = "None"; and set ip "no-ip"
            test -z "$name" -o "$name" = "None"; and set name "unnamed"

            # Look up SSM ping status
            set -l ping "No SSM"
            for ssm_row in $ssm_lines
                set -l ssm_fields (string split \t -- $ssm_row)
                if test "$ssm_fields[1]" = "$id"
                    set ping $ssm_fields[2]
                    break
                end
            end

            set -a lines (printf "%-22s │ %-30s │ %-10s │ %-12s │ %s" "$id" "$name" "$state" "$ping" "$ip")
        end

        if test (count $lines) -eq 0
            echo "❌ No instances found with your creator tag in $region"
            return 1
        end

        set -l header (printf "%-22s │ %-30s │ %-10s │ %-12s │ %s" "INSTANCE ID" "NAME" "STATE" "SSM PING" "IP")
        set -l selection (printf '%s\n' $lines | fzf --header="$header" --height=40% --reverse)

        if test -z "$selection"
            echo "❌ No instance selected"
            return 1
        end

        # Extract instance ID (first field before the │)
        set instance_id (string split "│" -- $selection)[1]
        set instance_id (string trim -- $instance_id)
    end

    # Confirm before proceeding
    echo ""
    set_color yellow
    echo "⚠️  This will remove Teleport from instance: $instance_id"
    set_color normal
    echo "   Region: $region"
    echo ""
    echo "   Actions:"
    echo "   • Stop and disable teleport service"
    echo "   • Remove /etc/teleport.yaml"
    echo "   • Remove /var/lib/teleport/"
    echo "   • Remove /etc/teleport-update.yaml"
    echo "   • Remove /etc/teleport.d/"
    echo ""
    read -P "🗑️  Proceed? [y/N] " answer
    if test "$answer" != "Y" -a "$answer" != "y"
        echo "❌ Cancelled"
        return 1
    end

    # Send SSM command
    echo ""
    set_color cyan
    echo "📡 Sending cleanup command..."
    set_color normal

    set -l command_id (aws ssm send-command \
        --document-name "AWS-RunShellScript" \
        --targets "Key=instanceids,Values=$instance_id" \
        --parameters 'commands=["echo Starting Teleport cleanup...","sudo systemctl stop teleport || true","sudo systemctl disable teleport || true","sudo rm -f /etc/teleport.yaml","sudo rm -rf /var/lib/teleport","sudo rm -f /etc/teleport-update.yaml","sudo rm -rf /etc/teleport.d","echo Teleport cleanup complete!"]' \
        --region $region \
        --query "Command.CommandId" \
        --output text 2>&1)

    if test $status -ne 0
        set_color red
        echo "❌ Failed to send SSM command: $command_id"
        set_color normal
        return 1
    end

    echo "   Command ID: $command_id"
    echo ""
    set_color cyan
    echo "⏳ Waiting for cleanup to complete..."
    set_color normal

    # Wait for cleanup command
    sleep 3

    set -l result (aws ssm get-command-invocation \
        --command-id "$command_id" \
        --instance-id "$instance_id" \
        --region $region 2>&1)

    if test $status -ne 0
        set_color yellow
        echo "⚠️  Could not get command status. Continuing to verification..."
        set_color normal
    else
        set -l cmd_status (echo $result | jq -r '.Status')
        if test "$cmd_status" = "Success"
            set_color green
            echo "✅ Cleanup command succeeded"
            set_color normal
        else if test "$cmd_status" = "InProgress"
            echo "   Still in progress, waiting..."
            sleep 3
        else
            set_color red
            echo "⚠️  Cleanup command status: $cmd_status"
            set_color normal
        end
    end

    # Verification step
    echo ""
    set_color cyan
    echo "🔍 Verifying cleanup..."
    set_color normal

    set -l verify_id (aws ssm send-command \
        --document-name "AWS-RunShellScript" \
        --targets "Key=instanceids,Values=$instance_id" \
        --parameters 'commands=["echo SERVICE_STATUS","systemctl is-active teleport 2>/dev/null || echo NOT_RUNNING","systemctl is-enabled teleport 2>/dev/null || echo NOT_ENABLED","echo CONFIG_CHECK","test -f /etc/teleport.yaml && echo FOUND_CONFIG || echo CLEAN_CONFIG","test -d /var/lib/teleport && echo FOUND_DATA || echo CLEAN_DATA","test -f /etc/teleport-update.yaml && echo FOUND_UPDATE || echo CLEAN_UPDATE"]' \
        --region $region \
        --query "Command.CommandId" \
        --output text 2>&1)

    if test $status -ne 0
        set_color yellow
        echo "⚠️  Could not send verification command"
        set_color normal
    else
        sleep 3

        set -l verify_result (aws ssm get-command-invocation \
            --command-id "$verify_id" \
            --instance-id "$instance_id" \
            --region $region 2>&1)

        if test $status -eq 0
            set -l verify_output (echo $verify_result | jq -r '.StandardOutputContent')
            
            echo ""
            set_color cyan
            echo "   Service Status:"
            set_color normal
            
            if string match -q "*NOT_RUNNING*" -- $verify_output
                set_color green
                echo "   ✅ Teleport service not running"
                set_color normal
            else if string match -q "*inactive*" -- $verify_output
                set_color green
                echo "   ✅ Teleport service inactive"
                set_color normal
            else
                set_color red
                echo "   ❌ Teleport service may still be running"
                set_color normal
            end
            
            if string match -q "*NOT_ENABLED*" -- $verify_output
                set_color green
                echo "   ✅ Teleport service not enabled"
                set_color normal
            else if string match -q "*disabled*" -- $verify_output
                set_color green
                echo "   ✅ Teleport service disabled"
                set_color normal
            else
                set_color red
                echo "   ❌ Teleport service may still be enabled"
                set_color normal
            end

            echo ""
            set_color cyan
            echo "   Config Files:"
            set_color normal

            if string match -q "*CLEAN_CONFIG*" -- $verify_output
                set_color green
                echo "   ✅ /etc/teleport.yaml removed"
                set_color normal
            else
                set_color red
                echo "   ❌ /etc/teleport.yaml still exists"
                set_color normal
            end

            if string match -q "*CLEAN_DATA*" -- $verify_output
                set_color green
                echo "   ✅ /var/lib/teleport removed"
                set_color normal
            else
                set_color red
                echo "   ❌ /var/lib/teleport still exists"
                set_color normal
            end

            if string match -q "*CLEAN_UPDATE*" -- $verify_output
                set_color green
                echo "   ✅ /etc/teleport-update.yaml removed"
                set_color normal
            else
                set_color red
                echo "   ❌ /etc/teleport-update.yaml still exists"
                set_color normal
            end
        end
    end

    echo ""
    set_color cyan
    echo "📋 Next steps:"
    set_color normal
    echo "   1. Mark the issue as resolved in Teleport UI"
    echo "   2. Discovery will re-enroll the instance with the correct cluster"
end

# Completions for tad
complete -c tad -s r -l region -d "AWS region" -xa "us-west-2 us-east-1 us-east-2 eu-west-1 eu-central-1"
