# New Mac Setup Guide

Complete setup guide for a new machine based on these dotfiles.

## Phase 1: Bootstrap (Before Anything Else)

### 1. Xcode Command Line Tools

```bash
xcode-select --install
```

This gives you `git` and other essential build tools.

### 2. SSH Keys for GitHub

Generate a new SSH key using Ed25519 (modern, fast, secure):

```bash
ssh-keygen -t ed25519 -C "email address"
```

> **What is Ed25519?** It's an elliptic curve algorithm that produces smaller keys (256 bits) with the same security as RSA 4096-bit keys, but faster. It's what GitHub recommends.

Start the SSH agent and add your key:

```bash
eval "$(ssh-agent -s)"
```

Create or edit `~/.ssh/config`:

```bash
mkdir -p ~/.ssh
cat >> ~/.ssh/config << 'EOF'
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
```

Add the key to your macOS keychain:

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Copy the public key to clipboard:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Add it to GitHub:

1. Go to <https://github.com/settings/keys>
2. Click "New SSH key"
3. Paste the key and save

Test the connection:

```bash
ssh -T git@github.com
```

You should see: "Hi carlisia! You've successfully authenticated..."

### 3. Clone Your Dotfiles

```bash
mkdir -p ~/code/src/github.com/carlisia
cd ~/code/src/github.com/carlisia
git clone git@github.com:carlisia/dotfiles.git
```

## Phase 2: Package Manager and Core Tools

### 4. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

For this session only (until Fish is set up):

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Once Fish is installed and stowed, your `config.fish` handles the PATH automatically.

- <https://brew.sh>

### 5. Git (Homebrew version + LFS)

```bash
brew install git
brew install git-lfs
git lfs install
```

### 6. GNU Stow (Dotfile Symlinking)

```bash
brew install stow
```

## Phase 3: Shell and Terminal

### 7. Fish Shell

```bash
brew install fish
# Add to allowed shells
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
# Set as default
chsh -s /opt/homebrew/bin/fish
```

- <https://fishshell.com>

Then stow it:

```bash
cd ~/code/src/github.com/carlisia/dotfiles
stow fish -t $HOME
```

### 8. Fisher (Fish Plugin Manager)

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

Fish plugins to install:

```bash
fisher install jethrokuan/z          # Directory jumping (the 'j' alias)
fisher install PatrickF1/fzf.fish    # FZF integration
```

### 9. Ghostty Terminal

Download from: <https://ghostty.org/download>

Then stow config:

```bash
stow ghostty -t $HOME
```

### 10. Starship Prompt

```bash
brew install starship
stow starship -t $HOME
```

- <https://starship.rs>

## Phase 4: Fonts

```bash
brew install --cask font-fira-code
brew install --cask font-jetbrains-mono
brew install --cask font-symbols-only-nerd-font
brew install --cask font-maple-mono
```

Ghostty config uses: Fira Code, Maple Mono, Symbols Nerd Font

## Phase 5: Neovim

```bash
brew install neovim
```

- <https://neovim.io>

Then stow your config:

```bash
stow nvim -t $HOME
```

First launch will auto-install plugins via Lazy.nvim.

## Phase 6: CLI Power Tools

```bash
# Essential CLI upgrades
brew install bat          # Better cat
brew install eza          # Better ls
brew install fzf          # Fuzzy finder
brew install ripgrep      # Better grep (rg)
brew install fd           # Better find
brew install trash        # Safe rm alternative
brew install yazi         # Terminal file manager
brew install zellij       # Terminal multiplexer
brew install lazygit      # Git TUI
brew install diff-so-fancy # Pretty git diffs
brew install delta        # Even prettier diffs
```

Stow their configs:

```bash
cd ~/code/src/github.com/carlisia/dotfiles
stow bat -t $HOME
stow eza -t $HOME
stow yazi -t $HOME
stow zellij -t $HOME
stow lazygit -t $HOME
```

## Phase 7: Git Configuration

```bash
stow git -t $HOME
```

For GPG commit signing:

```bash
brew install gnupg
brew install pinentry-mac
# Import your GPG key, then:
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

## Phase 8: GitHub CLI

```bash
brew install gh
gh auth login
stow gh -t $HOME
```

## Phase 9: Development Languages

### Go

```bash
brew install go
```

Config expects: `GOPATH=~/code` and `GOBIN=~/code/bin`

### Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

- <https://rustup.rs>

### Python

```bash
brew install python
```

### Node.js (for LSPs and prettierd)

```bash
brew install node
```

## Phase 10: LSP and Dev Tools (For Neovim)

```bash
# Lua
brew install lua-language-server
brew install stylua
brew install luarocks
luarocks install luacheck

# Bash
npm install -g bash-language-server
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Prettier
npm install -g @fsouza/prettierd

# Markdown
brew install markdownlint-cli
```

## Phase 11: Kubernetes Tools

```bash
brew install kubectl
brew install k9s
stow k9s -t $HOME
```

## Phase 12: Optional

```bash
brew install --cask visual-studio-code  # Git difftool
brew install coreutils                   # GNU coreutils
```

## Quick Install Script

After SSH keys are set up and dotfiles are cloned:

```bash
# Homebrew (run first, then restart terminal)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Core tools
brew install git git-lfs stow fish starship neovim

# CLI upgrades
brew install bat eza fzf ripgrep fd trash yazi zellij lazygit diff-so-fancy delta

# Languages
brew install go python node

# Fonts
brew install --cask font-fira-code font-jetbrains-mono font-symbols-only-nerd-font font-maple-mono

# Kubernetes
brew install kubectl k9s

# GitHub
brew install gh
```
