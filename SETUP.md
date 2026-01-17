# New mac setup guide

Setup guide for a new machine based on these dotfiles.

## Bootstrap (before anything else)

### Xcode command line tools

```bash
xcode-select --install
```

This provides `git` and other essential build tools.

### Show hidden files in Finder

```bash
defaults write com.apple.finder AppleShowAllFiles YES && killall Finder
```

## Package manager and core tools

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

For this session only (until Fish is set up):

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Once Fish is installed and stowed, your `config.fish` handles the PATH automatically.

### Fish shell

```bash
brew install fish
# Add to allowed shells
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
# Set as default
chsh -s /opt/homebrew/bin/fish
```

### Fisher (fish plugin manager)

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

Fish plugins to install:

```bash
fisher install jethrokuan/z          # Directory jumping (the 'j' alias)
fisher install PatrickF1/fzf.fish    # FZF integration
```

### Cli power tools

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

### Tools

```bash
brew install git # note: check if xcode-select already installed git
brew install git-lfs
git lfs install
brew install gh
brew install starship
brew install neovim
brew install stow
brew install tree-sitter tree-sitter-cli
brew install ghostty
rm -rf ~/Library/Application\ Support/com.mitchellh.ghostty # to remove default config file
```

### Kubernetes tools

```bash
brew install kubectl
brew install k9s
brew install lens
```

### Karabiner

Download from: <https://karabiner-elements.pqrs.org/>

After stowing or making changes to the config, restart Karabiner:

```bash
killall karabiner_console_user_server && open -a "Karabiner-Elements"
```

## Github config

### Ssh keys

Generate a new SSH key using Ed25519 (modern, fast, secure):

```bash
ssh-keygen -t ed25519 -C "email address"
```

> **What is Ed25519?** It's an elliptic curve algorithm that produces smaller keys (256 bits) with the same security as RSA 4096-bit keys, but faster. It's what GitHub recommends.

Start the SSH agent and add your key:

```bash
eval "$(ssh-agent -s)"
```

Create or edit `~/.ssh/config` (replace `id_ed25519` with your key filename if different):

```bash
mkdir -p ~/.ssh
cat >> ~/.ssh/config << 'EOF'
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
```

Add the key to your macOS keychain (replace `id_ed25519` if you used a different name):

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

### Github cli

```bash
gh auth login
```

## Dotfiles

### Clone the dotfiles

```bash
mkdir -p ~/code/src/github.com/carlisia
cd ~/code/src/github.com/carlisia
git clone git@github.com:carlisia/dotfiles.git
```

### My tools

Install `markin`

### Stow dotfiles

After cloning the dotfiles, create symlinks for all configurations.

> This can be done before installing the actual tools - the configs will be ready when you install each tool.

```bash
cd ~/code/src/github.com/carlisia/dotfiles

# Shell and terminal
stow fish -t $HOME
stow starship -t $HOME
stow ghostty -t $HOME

# Development tools
stow gh -t $HOME
stow git -t $HOME
stow nvim -t $HOME

# CLI utilities
stow bat -t $HOME
stow eza -t $HOME
stow yazi -t $HOME
stow zellij -t $HOME
stow lazygit -t $HOME

# Kubernetes tools
stow k9s -t $HOME

# macOS apps
stow karabiner -t $HOME

stow markin -t $HOME
```

### Fonts

```bash
brew install --cask font-fira-code
brew install --cask font-jetbrains-mono
brew install --cask font-symbols-only-nerd-font
brew install --cask font-maple-mono
```

Ghostty config uses: Fira Code, Maple Mono, Symbols Nerd Font

## Essential apps

### Macos accessibility permissions

For global keybindings to work (like `ctrl+shift+p` for the quick terminal), Ghostty needs Accessibility permissions. Ensure this is set:

1. Open **System Settings** → **Privacy & Security** → **Accessibility**
2. Look for **Ghostty** in the list and enable it
3. If Ghostty isn't listed, click the `+` button and add it from `/Applications/`
4. Restart Ghostty after granting permissions

### Shared apps

#### Alfred

Download from: <https://www.alfredapp.com/>

1. Install and enter Powerpack license
2. Set up syncing: Go to Advanced tab → Syncing section → "Set preferences folder..."
3. Enable automatic snippet expansion: Features → Snippets → Automatically expand snippets by keyword (if not already set)
4. Check clipboard settings: Features → Clipboard History → Configure history limits and preferences

#### Moom

Download from: <https://manytricks.com/moom/>

1. Install and enter license
2. Import custom actions: Preferences → Custom → Import → Select `Actions.moom` file

#### Dash

Download from: <https://kapeli.com/dash>

Enable Alfred integration: Preferences → Integration → Alfred

#### Bartender

Download from: <https://www.macbartender.com/>

1. Install and enter license
2. Configure menu bar items as desired

**Sharing config between machines:**

Bartender stores settings in `~/Library/Preferences/com.surteesstudios.Bartender.plist`.

#### Keyboard Maestro

### Not shared by config files

- cleanshot
- steer mouse
- el gato control center

- apptorium
  - sidenotes
  - fivenotes
  - cursor teleporter

## Other apps

- **Textastic** - Text and code editor
- **AppZapper** - App uninstaller
- **Flacbox** - FLAC audio player
- PDF Explorer
- Zotero
- Stream Deck
- ecamm/OBS

## Development languages

### Go

```bash
brew install go
```

Config expects: `GOPATH=~/code` and `GOBIN=~/code/bin`

### Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Python

```bash
brew install python
```

### Node.js

```bash
brew install node
```

Required for various LSP servers and formatters.

### Environment variables

```bash
set --Ugx SECOND_BRAIN (using Obsidian remote, this path will be the local vault, not the remote)
```

### Additional dependencies

Install shell-color-scripts for nvim/nvchad/snack dashboard:

```bash
curl -L https://gitlab.com/dwt1/shell-color-scripts/-/archive/master/shell-color-scripts-master.tar.gz | tar xz -C /tmp
mkdir -p ~/.local/bin ~/.local/share/shell-color-scripts
cp -rf /tmp/shell-color-scripts-master/colorscripts ~/.local/share/shell-color-scripts/
cp /tmp/shell-color-scripts-master/colorscript.sh ~/.local/bin/colorscript
chmod +x ~/.local/bin/colorscript
```

Install Lua 5.1 for compatibility:

```bash
cd /tmp
curl -L https://www.lua.org/ftp/lua-5.1.5.tar.gz | tar xz
cd lua-5.1.5/src && make macosx
mkdir -p ~/.local/lua51/bin
cp lua luac ~/.local/lua51/bin/
ln -sf ~/.local/lua51/bin/lua ~/.local/bin/lua5.1
```

Install jsregexp for LuaSnip (needed for LSP snippet transformations):

```bash
luarocks --local --lua-version 5.1 install jsregexp
```

### Lsp servers and tools

Install Lua tools:

```bash
brew install lua-language-server
brew install stylua
brew install luarocks
luarocks install luacheck
```

Install Bash tools:

```bash
npm install -g bash-language-server
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

Install Prettier:

```bash
npm install -g @fsouza/prettierd
```

Install Markdown tools:

```bash
brew install markdownlint-cli
```

## Git commits - gpg commit signing

Install GPG tools:

```bash
brew install gnupg
brew install pinentry-mac
```

Generate GPG keys (one for personal, one for work):

```bash
# Personal key
gpg --quick-generate-key "Your Name <personal@email.com>" rsa4096 default 0

# Work key
gpg --quick-generate-key "Your Name (Work) <work@email.com>" rsa4096 default 0
```

List your keys to get the key IDs:

```bash
gpg --list-secret-keys --keyid-format=long
```

Update the signing keys in:

- `~/.config/git/config` - personal key ID
- `~/.config/git/config-work` - work key ID

Configure pinentry for macOS Keychain integration:

```bash
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

This enables GPG passphrase caching via macOS Keychain. On your first commit with each key, you'll be prompted for the passphrase with an option to save it to Keychain. After that, commits won't require re-entering the passphrase.

## Optional

```bash
brew install --cask visual-studio-code  # Git difftool
brew install coreutils                  # GNU coreutils
```
