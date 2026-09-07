function ggl --description "Git graph log for current branch: ggl [days=3] [max commits]"
    set -l days 3
    test (count $argv) -ge 1; and set days $argv[1]

    set -l limit
    test (count $argv) -ge 2; and set limit -n $argv[2]

    git log $limit \
        --pretty=format:'%C(auto)%h %C(green)%cd%C(reset) %C(blue)%an%C(reset) %s%C(auto)%d' \
        --date=format-local:'%Y-%m-%d %I:%M%p' \
        --graph --abbrev-commit --since="$days days ago"
end
