# Nuke an EC2 instance: clean Teleport agent via tad, then terminate the instance.
# Use this when you want a completely fresh instance for re-enrollment testing.

function ec2d --description "Clean Teleport agent + terminate EC2 instance"
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

    # Pre-flight: ensure tsh session is valid
    if not dtsh status &>/dev/null
        echo "❌ tsh session expired. Run 'tu' first."
        return 1
    end

    # Refresh AWS SSO session if expired
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end

    # If no instance ID provided, list tagged instances via fzf
    if test -z "$instance_id"
        echo "🔍 Fetching your EC2 instances in $region..."

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
            echo "   No instances found."
            return 0
        end

        # Get SSM status for all instances in one call
        set -l ssm_lines (aws ssm describe-instance-information \
            --region $region \
            --query "InstanceInformationList[].[InstanceId, PingStatus]" \
            --output text 2>&1)

        # Build fzf-friendly list
        set -l lines
        for row in $ec2_lines
            set -l fields (string split \t -- $row)
            set -l id $fields[1]
            set -l state $fields[2]
            set -l ip $fields[3]
            set -l name $fields[4]

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
            echo "   No instances found."
            return 0
        end

        set -l header (printf "%-22s │ %-30s │ %-10s │ %-12s │ %s" "INSTANCE ID" "NAME" "STATE" "SSM PING" "IP")
        set -l selection (printf '%s\n' $lines | fzf --header="$header" --height=40% --reverse --prompt="💣 Nuke instance> ")

        if test -z "$selection"
            echo "   No instance selected."
            return 0
        end

        set instance_id (string split "│" -- $selection)[1]
        set instance_id (string trim -- $instance_id)
    end

    # Confirm the nuke
    echo ""
    set_color red
    echo "💣 NUKE: Clean agent + terminate instance: $instance_id"
    set_color normal
    echo "   Region: $region"
    echo ""
    echo "   Actions:"
    echo "   • Run tad to clean Teleport agent + remove discovery configs"
    echo "   • Terminate the EC2 instance"
    echo ""
    read -P "💣 Proceed? [y/N] " answer
    if test "$answer" != "Y" -a "$answer" != "y"
        echo "   Aborted."
        return 0
    end

    # Step 1: Run tad to clean agent and discovery configs
    echo ""
    echo "── Step 1: Clean Teleport agent ──"
    tad --region $region $instance_id

    # Step 2: Terminate the EC2 instance
    echo ""
    echo "── Step 2: Terminate EC2 instance ──"
    set_color cyan
    echo "🔥 Terminating instance $instance_id..."
    set_color normal

    set -l term_result (aws ec2 terminate-instances \
        --instance-ids $instance_id \
        --region $region \
        --query "TerminatingInstances[0].CurrentState.Name" \
        --output text 2>&1)

    if test $status -ne 0
        set_color red
        echo "❌ Failed to terminate instance: $term_result"
        set_color normal
        return 1
    end

    set_color green
    echo "✅ Instance terminating (state: $term_result)"
    set_color normal

    echo ""
    set_color cyan
    echo "📋 Next steps:"
    set_color normal
    echo "   Run 'ec2c' to create a fresh EC2 instance"
end

# Completions for ec2d
complete -c ec2d -s r -l region -d "AWS region" -xa "us-west-2 us-east-1 us-east-2 eu-west-1 eu-central-1"
