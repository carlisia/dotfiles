#!/usr/bin/bash
 
 if [ -z "$USER" ]; then
    USER=$(id -un)
fi

echo >&2 "====================================================================="
echo >&2 " Setting up codespaces environment"
echo >&2 ""
echo >&2 " USER        $USER"
echo >&2 " HOME        $HOME"
echo >&2 "====================================================================="

cd "$HOME" || exit

# Make passwordless sudo work
export SUDO_ASKPASS=/bin/true

# No thank you
rm -rf .oh-my-bash
rm -rf .oh-my-zsh
rm .zshrc

# A bit of a hack
mv .gitconfig .gitconfig.private

# Install fzf
FZF_VERSION=0.30.0
curl -L https://github.com/junegunn/fzf/releases/download/"${FZF_VERSION}"/fzf-"${FZF_VERSION}"-linux_amd64.tar.gz | tar xzC "$HOME"/bin

# Install neovim
NVIM_VERSION=0.7.0
sudo apt-get install -y libfuse2
curl -L -o "$HOME"/bin/nvim https://github.com/neovim/neovim/releases/download/v"${NVIM_VERSION}"/nvim.appimage
chmod a+x "$HOME"/bin/nvim

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install stow

stow base16-shell -t "$HOME"

stow fish -t "$HOME"

stow gh -t "$HOME"

stow git -t "$HOME"

stow lvim -t "$HOME"

stow nvim -t "$HOME"

stow starfish -t "$HOME"

