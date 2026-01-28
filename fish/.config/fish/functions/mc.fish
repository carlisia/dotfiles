# Create cloud tenant

function mc --description "Create cloud tenant with RELEASE"
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
    make -C e TENANT=$tenant RELEASE=$ver create-cloud
end
