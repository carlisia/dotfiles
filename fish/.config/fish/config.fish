set -x SHELL /usr/local/bin/fish

# prompt stuff
set -x GIT_TERMINAL_PROMPT 1
# alias zen=fish_greeting
starship init fish | source

# if status --is-interactive
#     and not set -q TMUX
#     exec tmux
# end

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell"
    source "$BASE16_SHELL/profile_helper.fish"
end

# For gpg keys
# set -gx GPG_TTY /dev/ttys054

set -x GOPATH $HOME/working

set -x EDITOR code
alias vim=nvim
alias vi=nvim

# So we can run go commands and go programs we have compiled ourselves
set -x PATH $PATH /usr/local/go/bin /usr/local/bin /usr/local/sbin $GOPATH/bin /Users/carlisiac /Users/carlisiac/Kui-darwin-x64 /Users/carlisiac/dotfiles /usr/local/bin/golangci-lint /usr/local/kubebuilder/bin $HOME/.gem/ruby/2.7.0/bin $HOME/.krew/bin /Users/carlisiac/.cargo/bin fish fish_indent /Users/carlisiac/working/src/github.com/carlisia/dotfiles/other-configs/scripts/jq-script /Users/carlisiac/.local/bin /Users/carlisiac/.config/lvim/config

alias python="python3"
alias g="git status -sb"

alias dev="eval sh /Users/carlisiac/working/src/github.com/carlisia/dotfiles/other-configs/scripts/tmux-scripts/workspace"

alias j="z"
alias c="code ."

alias k kubectl
alias gp "k get pods"
alias gn "k get nodes"
alias gd "k get deploy"
alias gr "k get rs"
alias gs "k get ns"

alias pka "pbpaste | kubectl apply -f-"
alias pkr "pbpaste | kubectl delete -f-"

# # alias knd "bass source /Users/carlisiac/working/src/github.com/carlisia/dotfiles/scripts/kind-with-registry.sh"

alias ks kube-shell

if [ ! -n "$__shhist_session" ]
    if [ -n "$TERM_SESSION_ID" ]
        set __shhist_session $TERM_SESSION_ID
    else
        set __shhist_session (random)-$fish_pid
    end
end

# function fish_greeting
#     # echo The time is (set_color yellow; date +%T; set_color normal)
#     # echo
#     # gh zen
# end

# alias h="shhist search"
alias h="history search"
alias gg="garden"
alias gita="python3 -m gita"

# gh cli / to be run inside a repo directory
alias pr="gh pr list | fzf"
alias co="gh co"

# iTerm2 shell integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/carlisiac/Downloads/google-cloud-sdk/path.fish.inc' ]; . '/Users/carlisiac/Downloads/google-cloud-sdk/path.fish.inc'; end
