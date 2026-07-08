function gga --description "Git graph log for all branches, last N days (default 3)"
    set -l days (test (count $argv) -gt 0; and echo $argv[1]; or echo 3)
    git log --pretty=format:'%C(auto)%h %C(green)%cd%C(reset) %C(blue)%an%C(reset) %s%C(auto)%d' --date=short --graph --abbrev-commit --all --since="$days days ago"
end
