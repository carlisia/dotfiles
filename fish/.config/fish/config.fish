if status --is-interactive
and not set -q TMUX
    exec tmux
end

# Base16 Shell
if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell"
    source "$BASE16_SHELL/profile_helper.fish"
end

starship init fish | source

set -x SHELL /usr/local/bin/fish

set -x GIT_TERMINAL_PROMPT 1

# For gpg keys
set -gx GPG_TTY /dev/ttys054

set -g fish_user_paths /usr/local/bin $fish_user_paths

fish_add_path /usr/local/sbin

set -x -U GOPATH $HOME/working

set -x EDITOR "nvim"

# So we can run go commands and go programs we have compiled ourselves
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin /Users/carlisiac /Users/carlisiac/Kui-darwin-x64 /Users/carlisiac/dotfiles /usr/local/bin/golangci-lint /usr/local/kubebuilder/bin $HOME/.gem/ruby/2.7.0/bin

# To have ruby first in the PATH:
set -g fish_user_paths "/usr/local/opt/ruby/bin" $fish_user_paths
# For compilers to find ruby:
set -gx LDFLAGS "-L/usr/local/opt/ruby/lib"
set -gx CPPFLAGS "-I/usr/local/opt/ruby/include"

alias g "git status -sb"
alias ll "git log --oneline"
alias l1 "git lg1"
alias l2 "git lg2"
alias l0 "git lg"
alias gl "git l0"
alias ks "kube-shell"
alias dev "eval sh /Users/carlisiac/working/src/github.com/carlisia/dotfiles/other-configs/scripts/tmux-scripts/workspace"
alias c "code ."

alias k "kubectl"
alias gp "k get pods"
alias gn "k get nodes"
alias gd "k get deploy"
alias gr "k get rs"
alias gs "k get ns"

alias v "/Users/carlisiac/working/src/github.com/vmware-tanzu/velero/_output/bin/darwin/amd64/velero"
alias t "/Users/carlisiac/working/src/github.com/vmware-tanzu/velero/_tiltbuild/local/velero"

alias knd "bass source /Users/carlisiac/working/src/github.com/carlisia/dotfiles/scripts/kind-with-registry.sh"

alias vim="nvim"
alias vi="nvim"

alias ks="kube-shell"

# ssh vm

set -x KUBE_EDITOR "nvim"

alias pbk "pbpaste | kubectl apply -f -"

alias s- "set -x KUBECONFIG $HOME/.kube/kind-config-staging ;and kubens velero"
alias d- "set -x KUBECONFIG $HOME/.kube/kind-config-development;and kubens velero"

# set -x KIND0 $HOME/.kube/velero-cluster-a.kubeconfig
# set -x KIND1 $HOME/.kube/velero-cluster-b.kubeconfig
set -x KIND2 $HOME/.kube/config
set -x KIND3 $HOME/.kube/kind-config-development
# # set -x AZURE $HOME/.kube/azure
set -x KUBECONFIG $KIND2:$KIND3

fish_vi_key_bindings

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/carlisiac/dotfiles/google-cloud-sdk/path.fish.inc' ]; . '/Users/carlisiac/dotfiles/google-cloud-sdk/path.fish.inc'; end

# The next line enables shell command completion for gcloud.
# bass source '/Users/carlisiac/dotfiles/google-cloud-sdk/completion.bash.inc'

# To enable auto-switching of Rubies specified by .ruby-version files:
# bass source /usr/local/share/chruby/chruby.sh
# bass source /usr/local/opt/chruby/share/chruby/auto.sh

set -x LANG en_US.UTF-8

[ -f /usr/local/share/autojump/autojump.fish ];
source /usr/local/share/autojump/autojump.fish
