# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Customize Oh My Fish configuration path.
# set -gx OMF_CONFIG "/Users/carlisia/.config/omf"

set -x VAGRANT_DEFAULT_PROVIDER "virtualbox"
# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

set -x GOPATH "$HOME/work"

# So we can run go commands and go programs we have compiled ourselves
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin /Users/carlisia

alias g "git status"
alias l1 "git lg1"
alias l2 "git lg2"
alias l0 "git lg"
alias gl "git l0"

alias k "kubectl"
alias cp "aws-vault exec dev-cpinto"

# ssh vm


# fish theme: bobthefish
set -g theme_display_git_ahead_verbose yes
set -g theme_display_hg yes
set -g theme_title_display_process yes
set -g theme_display_vagrant yes
set -g theme_display_vi yes
set -g theme_git_worktree_support yes
set -g theme_nerd_fonts yes
set -g theme_show_exit_status yes
set -g theme_color_scheme dark

# Base16 Shell
if status --is-interactive
    eval sh $HOME/.config/base16-shell/scripts/base16-default-dark.sh
end

set -x SHELL /usr/local/bin/fish

set -x KUBECONFIG $HOME/.kube/my-cluster
set -x AWS_SHARED_CREDENTIALS_FILE $HOME/.aws/credentials

fish_vi_key_bindings