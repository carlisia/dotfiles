# Alias for tec2-clean (Teleport Agent Delete)

function tad --description "Remove Teleport agent from EC2 via SSM (alias for tec2-clean)"
    tec2-clean $argv
end

complete -c tad -s r -l region -d "AWS region" -xa "us-west-2 us-east-1 us-east-2 eu-west-1 eu-central-1"
