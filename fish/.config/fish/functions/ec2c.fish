# Create or restore the staging EC2 instance via Terraform.
# Runs terraform apply on the parent staging directory which provisions
# the EC2 instance, security group, SSH key, and discovery integration.

function ec2c --description "Create staging EC2 instance via Terraform"
    set -l staging_dir ~/code/src/github.com/gravitational/teleport-dev-infra/aws/staging

    # Pre-flight: ensure tsh session is valid
    if not dtsh status &>/dev/null
        echo "❌ tsh session expired. Run 'tu' first."
        return 1
    end

    # Refresh Teleport provider creds
    echo "── Refreshing Terraform provider creds ──"
    eval "$(dtctl terraform env)"
    or begin; echo "Failed to load Teleport provider creds."; return 1; end

    # Refresh AWS SSO session if expired
    if not aws sts get-caller-identity &>/dev/null
        echo "── Refreshing AWS credentials ──"
        aws sso login
        or begin; echo "AWS SSO login failed."; return 1; end
    end

    # Init and apply
    echo ""
    echo "── Initializing Terraform ──"
    terraform -chdir=$staging_dir init -input=false >/dev/null
    or begin; echo "❌ Terraform init failed."; return 1; end

    echo ""
    echo "── Applying staging configuration ──"
    terraform -chdir=$staging_dir apply
    or begin; echo "❌ Terraform apply failed."; return 1; end

    # Show instance details
    echo ""
    set_color green
    echo "✅ Staging infrastructure ready"
    set_color normal

    set -l public_ip (terraform -chdir=$staging_dir output -raw ec2_public_ip 2>/dev/null)
    if test -n "$public_ip"
        echo "   EC2 public IP: $public_ip"
    end

    echo ""
    set_color cyan
    echo "📋 Next steps:"
    set_color normal
    echo "   Run 'ttc' to apply a test case"
end
