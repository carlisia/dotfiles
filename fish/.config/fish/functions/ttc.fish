function ttc --description 'Prep and run a staging discovery test case'
    set -l staging_dir $WORK_TELEPORT_STAGING_DIR

    # Pre-flight: ensure tsh session is valid
    if not dtsh status &>/dev/null
        echo "tsh session expired. Run 'tu' first."
        return 1
    end

    # Refresh Teleport provider creds (short-lived, always get fresh ones)
    echo "── Refreshing Terraform provider creds ──"
    eval "$(dtctl terraform env)"
    or begin
        echo "Failed to load Teleport provider creds. Run 'te' manually."
        return 1
    end

    # Refresh AWS SSO session if expired (needed for terraform AWS provider)
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end

    # Step 1: Destroy main discovery config (keeps integration, IAM role, token intact)
    echo "── Step 1: Destroying main staging discovery config ──"
    terraform -chdir=$staging_dir init -input=false >/dev/null
    terraform -chdir=$staging_dir destroy -target='module.aws_discovery.teleport_discovery_config.aws[0]'
    or return 1

    # Step 2: List nodes and select one to remove
    # The instance stays registered as a node from earlier enrollment.
    # If not removed, discovery will see it as already enrolled and skip it.
    echo ""
    echo "── Step 2: Select node to remove ──"
    set -l node_lines (dtctl get nodes --format=json 2>/dev/null | jq -r '.[] | "\(.metadata.name)\t\(.spec.hostname // "")\t\(.metadata.labels["aws/teleport.dev/creator"] // "")"')

    if test (count $node_lines) -eq 0
        echo "No nodes found, skipping removal."
    else if test (count $node_lines) -eq 1
        set -l node_name (string split \t $node_lines[1])[1]
        echo "Removing node: $node_name"
        dtctl rm "node/$node_name"
    else
        set -l selected (printf '%s\n' $node_lines | fzf --prompt="Remove node> " --header="name  hostname  creator (ESC to skip)" --delimiter='\t')
        if test -n "$selected"
            set -l node_name (string split \t $selected)[1]
            echo "Removing node: $node_name"
            dtctl rm "node/$node_name"
        else
            echo "Skipped node removal."
        end
    end

    # Step 3: Remove teleport agent from EC2 instance
    # The agent holds valid identity certs from the previous join. Even after
    # removing the node, the running agent will re-register itself immediately.
    # Cleaning up via SSM ensures the instance is truly unenrolled.
    echo ""
    echo "── Step 3: Remove teleport agent from EC2 instance ──"
    tad
    or return 1

    # Step 4: Select and apply test case
    echo ""
    echo "── Step 4: Select test case to apply ──"
    set -l tests (find $staging_dir -mindepth 2 -maxdepth 2 -type d -name 'tc*' 2>/dev/null | sort | string replace "$staging_dir/" '')

    if test (count $tests) -eq 0
        echo "No test directories found."
        return 1
    end

    set -l selected_test (printf '%s\n' $tests | fzf --prompt="Apply test> " --header="Select test case to create")
    if test -n "$selected_test"
        echo "Applying test: $selected_test"
        terraform -chdir=$staging_dir/$selected_test init -input=false
        terraform -chdir=$staging_dir/$selected_test apply
    else
        echo "No test selected."
    end
end
