# Teleport profile switcher - switch or create TELEPORT_HOME profiles
# Handles AWS auth and Teleport login

function tu --description "Switch or create TELEPORT_HOME profile with auth setup"
    # Requires work-private.fish (conf.d) — see work-private.fish.example
    if not set -q WORK_TELEPORT_CLUSTER_DOMAIN
        set -l private_conf ~/.config/fish/conf.d/work-private.fish
        if test -f "$private_conf"
            source "$private_conf"
        end
        if not set -q WORK_TELEPORT_CLUSTER_DOMAIN
            echo "🚫 Missing work-private config. Copy conf.d/work-private.fish.example → conf.d/work-private.fish"
            return 1
        end
    end

    set -l base ~/tsh_profiles
    set -l teleport_repo $WORK_TELEPORT_REPO_E

    set -l target
    set -l profile_name

    if test (count $argv) -gt 0
        # Direct mode - use argument as directory name
        set profile_name $argv[1]
        set target "$base/$profile_name"

        # If doesn't exist, offer to create
        if not test -d "$target"
            read -P "🚫 Profile '$profile_name' doesn't exist. Create it? [y/N] " answer
            if test "$answer" = "Y" -o "$answer" = "y"
                mkdir -p "$target"
                echo "✅ Created profile: $profile_name"
                # Ask for the actual proxy address
                set -l default_addr "$profile_name.$WORK_TELEPORT_CLUSTER_DOMAIN:443"
                read -P "🌐 Proxy address [$default_addr]> " proxy_input
                if test -n "$proxy_input"
                    echo "$proxy_input" >"$target/proxy-addr"
                else
                    echo "$default_addr" >"$target/proxy-addr"
                end
            else
                return 1
            end
        end
    else
        # Interactive mode with fzf
        if not type -q fzf
            echo "🚫 fzf is not installed"
            return 127
        end

        # Gather subdirectories
        set -l names
        if test -d "$base"
            for d in $base/*
                if test -d "$d"
                    set names $names (basename "$d")
                end
            end
        end

        # Add create option at top
        set -l options "+ Create new" $names

        # Prompt with fzf
        set -l sel (printf '%s\n' $options | fzf \
            --height=40% \
            --reverse \
            --prompt='🔐 TELEPORT_HOME> ' \
            --preview="test '{}' = '+ Create new' && echo 'Create a new profile' || test -f $base/{}/current-profile && /bin/cat $base/{}/current-profile || echo 'No active session'" \
            --preview-window=up:3:wrap)
        or return 130

        if test "$sel" = "+ Create new"
            read -P "📝 Profile name> " newname
            if test -z "$newname"
                echo "❌ No name entered"
                return 1
            end
            set profile_name $newname
            set target "$base/$profile_name"
            mkdir -p "$target"
            echo "✅ Created profile: $profile_name"
            # Ask for the actual proxy address
            set -l default_addr "$profile_name.$WORK_TELEPORT_CLUSTER_DOMAIN:443"
            read -P "🌐 Proxy address [$default_addr]> " proxy_input
            if test -n "$proxy_input"
                echo "$proxy_input" >"$target/proxy-addr"
            else
                echo "$default_addr" >"$target/proxy-addr"
            end
        else
            set profile_name $sel
            set target "$base/$sel"
        end
    end

    # Resolve absolute path
    set -l cwd (pwd)
    cd "$target"
    set -l abs (pwd -P)
    cd "$cwd"

    # Export TELEPORT_HOME and TENANT globally
    set -gx TELEPORT_HOME "$abs"
    set -gx TENANT "$profile_name"
    echo "✅ TELEPORT_HOME → "(string replace $HOME '~' $TELEPORT_HOME)
    echo "✅ TENANT → $TENANT"

    # Show current session info if available
    if test -f "$TELEPORT_HOME/current-profile"
        set_color cyan
        echo "   📡 Profile: "(command cat "$TELEPORT_HOME/current-profile")
        set_color normal
    end

    # --- Step 1: AWS Authentication ---
    echo ""
    set_color yellow
    echo "🔐 Step 1/4: AWS Authentication (deploy-cloud-login)"
    set_color normal

    set -l saved_aws_profile "$AWS_PROFILE"
    set -gx AWS_PROFILE $WORK_AWS_PROFILE_ECR
    echo "   AWS_PROFILE → $WORK_AWS_PROFILE_ECR (for deploy-cloud-login)"

    if test -d "$teleport_repo"
        # Ensure envtest.mk stub exists — e/Makefile includes it unconditionally
        # but it's only needed for the test-operator target, not deploy-cloud-login.
        set -l envtest_mk "$teleport_repo/../integrations/operator/envtest.mk"
        if not test -f "$envtest_mk"
            touch "$envtest_mk"
        end
        echo "   Running deploy-cloud-login..."
        make -C "$teleport_repo" deploy-cloud-login
        if test $status -ne 0
            set_color red
            echo "   ⚠️  AWS login failed - you may need to retry manually"
            set_color normal
        else
            echo "   ✅ AWS deploy-cloud-login authenticated"
        end
    else
        set_color red
        echo "   ⚠️  Teleport repo not found at "(string replace $HOME '~' $teleport_repo)
        echo "   Run manually: make -C <teleport-e-dir> deploy-cloud-login"
        set_color normal
    end

    # --- Step 2: AWS SSO for Terraform (IAM permissions) ---
    echo ""
    set_color yellow
    echo "🔐 Step 2/4: AWS SSO (teleport-dev-admin for Terraform)"
    set_color normal

    set -gx AWS_PROFILE $saved_aws_profile
    echo "   AWS_PROFILE → $saved_aws_profile"

    aws sso login
    if test $status -ne 0
        set_color red
        echo "   ⚠️  AWS SSO login failed - run 'aws sso login' manually"
        set_color normal
    else
        echo "   ✅ AWS SSO authenticated (IAM permissions available)"
    end

    # --- Step 3: Teleport Authentication ---
    echo ""
    set_color yellow
    echo "🔐 Step 3/4: Teleport Authentication"
    set_color normal

    # Read proxy address from profile file, or construct default
    set -l cluster_addr
    if test -f "$TELEPORT_HOME/proxy-addr"
        set cluster_addr (string trim (command cat "$TELEPORT_HOME/proxy-addr"))
    else
        set cluster_addr "$profile_name.$WORK_TELEPORT_CLUSTER_DOMAIN:443"
    end
    echo "   Logging into $cluster_addr..."

    tsh login --proxy="$cluster_addr"
    if test $status -ne 0
        set_color red
        echo "   ⚠️  Teleport login failed"
        set_color normal
    else
        echo "   ✅ Teleport authenticated"
        if test -f "$TELEPORT_HOME/current-profile"
            set_color cyan
            echo "   📡 Profile: "(command cat "$TELEPORT_HOME/current-profile")
            set_color normal
        end

        # Update kube namespace to match the tenant
        set -l kube_ns (string replace -a '.' '-' $WORK_TELEPORT_CLUSTER_DOMAIN)"-$profile_name"
        kubectl config set-context --current --namespace="$kube_ns" 2>/dev/null
        and echo "   ✅ Kube namespace → $kube_ns"
    end

    # --- Step 4: Update Terraform staging config ---
    echo ""
    set_color yellow
    echo "📝 Step 4/4: Terraform"
    set_color normal

    set -l staging_dir $WORK_TELEPORT_STAGING_DIR
    set -l locals_file "$staging_dir/locals.tf"

    if test -f "$locals_file"
        # Update teleport_proxy_public_addr to match the new profile
        sed -i '' "s|teleport_proxy_public_addr = \".*\"|teleport_proxy_public_addr = \"$cluster_addr\"|" "$locals_file"
        echo "   ✅ Updated locals.tf → $cluster_addr"

        set -l tfvars_file "$staging_dir/terraform.tfvars"
        if test -f "$tfvars_file"
            sed -i '' "s|teleport_proxy_public_addr = .*|teleport_proxy_public_addr = \"$cluster_addr\"|" "$tfvars_file"
            echo "   ✅ Updated terraform.tfvars → $cluster_addr"
        end
    else
        set_color red
        echo "   ⚠️  locals.tf not found at "(string replace $HOME '~' $locals_file)
        set_color normal
    end

    echo ""
    echo "   To apply staging config:"
    echo "     cd "(string replace $HOME '~' $staging_dir)
    echo "     te   # get short-lived Teleport provider creds"
    echo "     ta   # terraform apply"
    echo ""
    echo "   Aliases: ti=init, tp=plan, ta=apply, td=destroy, te=terraform env"

    echo ""
    set_color green
    echo "Ready. cd into staging dir to start working."
    set_color normal
end

# Completions for tu
complete -c tu -f -a "(for d in ~/tsh_profiles/*; test -d \$d && basename \$d; end)" -d "Teleport profile"
