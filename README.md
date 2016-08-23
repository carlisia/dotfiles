# dotfiles
To use any of my dotfiles as is, install [GNU stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html). Homebrew is an option if you are on Mac OS: http://brewformulas.org/Stow

## To get neovim + go-vim up and running
- If you don't have neovim installed: https://neovim.io/
- Copy or clone this repository
- Run stow for nvim

```
cd ~/dotfiles
stow -vv nvim
```

The above will create the proper symlink for neovim. All you have to do is boot neovim and run `:PlugInstall` and `:GoInstallBinaries`  

Edit the `nvim/.config/nvim/init.vim` as you wish. The existing `init.vim` is heavily a copy of Fatih's `init.vim`.


