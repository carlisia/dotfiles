function ggl --description "Git graph log for current branch, last N days (default 3)"
    set -l days (test (count $argv) -gt 0; and echo $argv[1]; or echo 3)
    git log --pretty=format:'%C(auto)%h %C(blue)%an%C(reset) %s%C(auto)%d' --graph --abbrev-commit --since="$days days ago"
end
