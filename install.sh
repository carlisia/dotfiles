#!/usr/bin/bash

if [ -z "$USER" ]; then
	USER=$(id -un)
fi

# THIS IS OUT OF DATE! (March 11, 2025)
# 🧨

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
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/codespace/.profile
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

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
ln -s "$HOME"/working/src/github.com/carlisia/dotfiles/nvim/lua/custom/ ~/.config/nvim/lua/

bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

stow nvim -t "$HOME"

stow starfish -t "$HOME"

#####NOTE: go over all the lsp, formatters, fonts,etc and figure out what needs installing in the system. Here are some.
# for nvim, need to install:
brew install luarocks
luarocks install luacheck
luarocks install lanes
npm install -g @fsouza/prettierd

# the language servers
brew install lua-language-server
npm i -g bash-language-server
go install mvdan.cc/sh/v3/cmd/shfmt@latest
brew install stylua


# @todo
# Install fish and fish themes + plugins
# fzf: fisher install PatrickF1/fzf.fish
# Install omf and install themes, or use starship
# Install a Nerd Font
# Install richgo, eza, peco, ripgrep
# brew install pngpaste (for obsidian) / kubectl
