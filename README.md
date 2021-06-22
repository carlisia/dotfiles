# dotfiles
To use any of my dotfiles as is, install [GNU stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). Homebrew is an option if you are on Mac OS: http://brewformulas.org/Stow

## Prerequisites

### stow

[Stow - GNU Project - Free Software Foundation - Install](https://www.gnu.org/software/stow/)

[Invoking Stow (Stow)](https://www.gnu.org/software/stow/manual/html_node/Invoking-Stow.html#Invoking-Stow)

`stow [options] [action flag] package …`

stow directory: this dotfiles directory.

stow target tree: points into a package in the stow directory.

Example:

stow -vv starship --target=$HOME

### Oh my fish

curl -L https://get.oh-my.fish | fish

Powerline fonts: https://github.com/powerline/fonts/tree/master/SourceCodePro

### git access

ssh key:
https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/

pgp key:
https://help.github.com/articles/generating-a-new-gpg-key/

## To get neovim + go-vim up and running
- If you don't have neovim installed: https://neovim.io/
- Copy or clone this repository under your root `(~/)` directory
- Run stow for nvim

```
cd <your-path>/dotfiles
stow -vv nvim --target=$HOME
```

The above will create the proper symlink for neovim. All you have to do is boot neovim and run `:PlugInstall` and `:GoInstallBinaries`  

Edit the `nvim/.config/nvim/init.vim` as you wish. The existing `init.vim` is heavily a copy of Fatih's `init.vim`.


