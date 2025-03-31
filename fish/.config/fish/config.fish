# Shell
set -gx SHELL /opt/homebrew/bin/fish
# XDG
set -gx XDG_CONFIG_HOME $HOME/.config
# CDPATH
set -gx CDPATH $XDG_CONFIG_HOME  # magic!

# Editor
set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# GPG
set -gx GPG_TTY (tty)

# Projects
set -gx PROJECTS $HOME/code/src/github.com/
set -gx VAULT_MAIN ~/Documents/02-Areas/vaults/second_brain

# Path
set -x fish_user_paths
fish_add_path $HOME
fish_add_path $HOME/.local/bin
fish_add_path $HOME/dotfiles
fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin

# Fish
set fish_greeting
function fish_user_key_bindings
    fish_vi_key_bindings
    commandline -f forward-char  # Enters insert mode by default
end

# Startship prompt
starship init fish | source

# Go
set -x GOPATH ~/go
set -x GOBIN $GOPATH/bin
fish_add_path $GOPATH $GOBIN

# Tmuxifier
fish_add_path ~/.tmuxifier/bin
eval (tmuxifier init - fish)

# ----- alaliases

alias g="git status -sb"

# Visual Studio Code – path escape
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

# Python & pip
alias python="python3"
alias pip="pip3"

alias vl="nvim leetcode.nvim"

# Tools
alias j="z" #zelda (jump to projects)

# ----- abbr

# Editor
abbr vim nvim
abbr vi nvim
abbr v nvim

# Git
abbr ggl "git log --pretty=oneline -n 20 --graph --abbrev-commit"
abbr ggsl "git shortlog --summary --numbered"

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
