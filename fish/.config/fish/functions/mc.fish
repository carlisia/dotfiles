# Create cloud tenant

function mc --description "Create cloud tenant with RELEASE"
    set -l teleport_repo_e $WORK_TELEPORT_REPO_E

    if not test -d "$teleport_repo_e"
        echo "❌ Teleport e/ repo not found at $teleport_repo_e"
        return 1
    end

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

    read -P "🏷️  RELEASE> " ver

    if test -z "$ver"
        echo "❌ No release entered"
        return 1
    end

    echo ""
    echo "🚀 Creating cloud $tenant with $ver..."
    make -C "$teleport_repo_e" TENANT=$tenant RELEASE=$ver create-cloud
end
