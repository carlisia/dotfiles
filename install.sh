#!/usr/bin/bash
 
if [ -z "$USER" ]; then
    USER=$(id -un)
fi

echo >&2 "====================================================================="
echo >&2 " Setting up codespaces environment (linux based)"
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

# Install fzf
FZF_VERSION=0.30.0
curl -L https://github.com/junegunn/fzf/releases/download/"${FZF_VERSION}"/fzf-"${FZF_VERSION}"-linux_amd64.tar.gz | tar xzC "$HOME"/bin

# Install neovim
NVIM_VERSION=0.7.0
sudo apt-get install -y libfuse2
curl -L -o "$HOME"/bin/nvim https://github.com/neovim/neovim/releases/download/v"${NVIM_VERSION}"/nvim.appimage
chmod a+x "$HOME"/bin/nvim

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# - Run  these two commands in your terminal to add Homebrew to your PATH:
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/codespace/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# - Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
# - We recommend that you install GCC:
    brew install gcc

brew install stow

stow base16-shell -t "$HOME"

stow fish -t "$HOME"

stow gh -t "$HOME"

stow git -t "$HOME"

bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install-neovim-from-release)

stow nvim -t "$HOME"

bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

stow lvim -t "$HOME"

stow starfish -t "$HOME"

