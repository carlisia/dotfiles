set -x SHELL /opt/homebrew/bin/fish
set -gx PATH /opt/homebrew/bin $PATH

set fish_greeting

starship init fish | source
set -x XDG_CONFIG_HOME $HOME/.config
set -x CDPATH ~/.config # magic!

set -x VAULT_MAIN ~/Documents/02-Areas/vaults/second_brain

# Use same preset as nvim/nvchad:
# for addr in $XDG_RUNTIME_DIR/nvim.*
#     nvim --server $addr --remote-send ':lua require("nvchad.utils").reload() <cr>'
# end

# if status --is-interactive
#     and not set -q TMUX
#     exec tmux
# end

# Base16 Shell
# if status --is-interactive
#     set BASE16_SHELL "$HOME/.config/base16-shell"
#     source "$BASE16_SHELL/profile_helper.fish"
# end

# For gpg keys
set -gx GPG_TTY (tty)

set -x EDITOR nvim

set -x PATH $PATH ~/.local/share/nvim/lsp_servers/yamlls/node_modules/yaml-language-server/bin /usr/local/go/bin /usr/local/bin /usr/local/sbin $HOME $HOME/Kui-darwin-x64 $HOME/dotfiles /usr/local/bin/golangci-lint /usr/local/kubebuilder/bin $HOME/.gem/ruby/2.7.0/bin $HOME/.krew/bin $HOME/.cargo/bin fish fish_indent $HOME/code/src/github.com/carlisia/dotfiles/other-configs/scripts $HOME/.local/bin
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /opt/homebrew/opt/coreutils/libexec/gnubin:$PATH

set -gx PATH $HOME//.tmuxifier/bin $PATH
eval (tmuxifier init - fish)

set -x GOPATH $HOME/code
set -x GOBIN $GOPATH/bin
set -x PATH $GOBIN $PATH

alias dev="eval sh $HOME/code/src/github.com/carlisia/dotfiles/other-configs/scripts/tmux-scripts/workspace"

alias j="z"

if type -q eza
  alias ll "eza -l -a --icons"
  alias llt "ll --tree"
end

alias p=peco

alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

alias k kubectl
alias gp "k get pods"
alias gn "k get nodes"
alias gd "k get deploy"
alias gr "k get rs"
alias gs "k get ns"

alias pka "pbpaste | kubectl apply -f-"
alias pkr "pbpaste | kubectl delete -f-"

# # alias knd "bass source $HOME/code/src/github.com/carlisia/dotfiles/scripts/kind-with-registry.sh"

alias ks kube-shell

alias dockly "docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock lirantal/dockly"
alias ld "lazydocker"

if [ ! -n "$__shhist_session" ]
    if [ -n "$TERM_SESSION_ID" ]
        set __shhist_session $TERM_SESSION_ID
    else
        set __shhist_session (random)-$fish_pid
    end
end

alias h="history search"
alias gg="garden"
alias gita="python3 -m gita"

# gh cli / to be run inside a repo directory
alias pr="gh pr list | fzf"
alias co="gh co"
alias gw="gh worktree"

alias vl="nvim leetcode.nvim"
alias vv="nvim ."
alias v=nvim
alias python="python3"
alias pip="pip3"
alias g="git status -sb"

alias l="git log --pretty=oneline -n 20 --graph --abbrev-commit"
alias cc="git shortlog --summary --numbered"

# iTerm2 shell integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Applications/gcloud/google-cloud-sdk/path.fish.inc' ]; . '/Applications/gcloud/google-cloud-sdk/path.fish.inc'; end

direnv hook fish | source
