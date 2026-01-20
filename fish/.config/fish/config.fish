# Shell
set -gx SHELL /opt/homebrew/bin/fish
# XDG
set -gx XDG_CONFIG_HOME $HOME/.config
# CDPATH
set -gx CDPATH $XDG_CONFIG_HOME  # magic!

# Editor
set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# GPG
set -gx GPG_TTY (tty)

# Projects
set -gx PROJECTS $HOME/code/src/github.com
set -gx VAULT_MAIN $SECOND_BRAIN
set -gx VAULT_DEV $SECOND_BRAIN/DEV

# Path
set -x fish_user_paths
fish_add_path $HOME
fish_add_path $HOME/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path /usr/local/bin

# Go
set -x GOPATH ~/code
set -x GOBIN $GOPATH/bin
fish_add_path $GOPATH $GOBIN

# Rust
fish_add_path $HOME/.cargo/bin

# Fish
set fish_greeting
function fish_user_key_bindings
    fish_vi_key_bindings
    commandline -f forward-char  # Enters insert mode by default
end

# shortcut s/command rm/\rm
function \rm --wraps=command
    command rm $argv
end

# Startship prompt
starship init fish | source

# Editor
alias vim nvim
alias vi nvim
alias v nvim

# ----- aliases# Git
alias g="git status -sb"
alias ggl "git log --pretty=oneline -n 20 --graph --abbrev-commit"
alias ggsl "git shortlog --summary --numbered"

# Visual Studio Code – path escape
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

# Python & pip
alias python="python3"
alias pip="pip3"

alias vl="nvim leetcode.nvim"

# Tools
alias j="z" #jethrokuan/z (jump to projects)
alias zz="zellij"

alias rm='echo "🧨 NOT REMOVED! Use `trash` or, for permanent deletion, `\rm`."; false'

# bat
alias cat='bat'
alias less='bat'
alias head='bat --line-range :10'
alias tail='bat --line-range -10:'
alias batdiff='git diff --name-only | xargs bat'

# ----- aliases teleport
 alias dteleport '~/code/src/github.com/gravitational/teleport/build/teleport'
 alias dtsh '~/code/src/github.com/gravitational/teleport/build/tsh'
 alias dtctl '~/code/src/github.com/gravitational/teleport/build/tctl'
 alias dtbot '~/code/src/github.com/gravitational/teleport/build/tbot'

 # Quick version check (fish syntax)
 alias dversions 'echo "Dev:" && ~/code/src/github.com/gravitational/teleport/build/teleport version && echo "" && echo "Release:" && teleport version 2>/dev/null; or echo "No release version installed"'

#previewer for fzf:
set -x FZF_DEFAULT_OPTS '--preview "bat --style=numbers --color=always --line-range :500 {}"'

# ----- abbr

# Kubernetes
abbr kk kubectl
abbr kkgp "kubectl get pods"
abbr kkgn "kubectl get nodes"
abbr kkgd "kubectl get deploy"
abbr kkgr "kubectl get rs"
abbr kkgs "kubectl get ns"

abbr kkpka "pbpaste | kubectl apply -f-"
abbr kkpkr "pbpaste | kubectl delete -f-"

# Eza – enhanced ls alternatives
if type -q eza
  abbr ll "eza -l -a --icons"
  abbr llt "eza -l -a --icons --tree"
end
