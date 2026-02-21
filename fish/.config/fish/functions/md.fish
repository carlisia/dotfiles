# Deploy to cloud tenant (with zig cross-compiler for Linux)

function md --description "Set version and deploy to cloud tenant"
    set -l teleport_repo $WORK_TELEPORT_REPO
    set -l teleport_repo_e $WORK_TELEPORT_REPO_E

    if not test -d "$teleport_repo"
        echo "❌ Teleport repo not found at $teleport_repo"
        echo "   Set WORK_TELEPORT_REPO to your teleport repo path"
        return 1
    end

    if not test -d "$teleport_repo_e"
        echo "❌ Teleport e/ repo not found at $teleport_repo_e"
        echo "   Set WORK_TELEPORT_REPO_E to your teleport e/ repo path"
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

    read -P "🏷️  BASE_IMAGE_TAG> " ver

    if test -z "$ver"
        echo "❌ No version entered"
        return 1
    end

    echo ""
    echo "🔨 Setting version to $ver..."
    make -C "$teleport_repo" -f version.mk setver VERSION=$ver || return 1

    echo ""
    echo "🚀 Deploying $ver to $tenant (using zig cross-compiler)..."
    env CC="zig cc -target x86_64-linux-gnu" CXX="zig c++ -target x86_64-linux-gnu" make -C "$teleport_repo_e" TENANT=$tenant BASE_IMAGE_TAG=$ver deploy-cloud
end
