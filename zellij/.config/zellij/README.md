# README

[Official documentation - Zellij User Guide](https://zellij.dev/documentation/)

[zellij-org/awesome-zellij: A list of awesome resources for zellij](https://github.com/zellij-org/awesome-zellij?tab=readme-ov-file)

> [!TIP]
> There is syntax highlighting for kdl files in neovim, but no formatter. Use `kdl-fmt --in-place % -i 2` to format those files.
> Install: [hougesen/kdlfmt: A formatter for kdl documents.](https://github.com/hougesen/kdlfmt)

## Favorite features

I love how this terminal emulator is very visually oriented out of the box, and makes it easy/easier to expand on the defaults. In particular, I am loving being able to swap layouts on the fly. It took me a bit of thinking to figure out how layouts and swap work so I could build my own just following the documentation, but that was because it took me a while to find out that they had examples/defaults on their repo. I go over how I use them here:

    [feat(ui): swap layouts and stacked panes by imsnif · Pull Request #2167 · zellij-org/zellij](https://github.com/zellij-org/zellij/pull/2167)

## Status/tab bar styling plugin

You can see what my tab bar looks like and how I implemented it by looking at this:

    [🎨 Community Showcase · dj95/zjstatus · Discussion #44](https://github.com/dj95/zjstatus/discussions/44#discussioncomment-12770553)

## Other awesome plugins I'm using

- [karimould/zellij-forgot: A Zellij plugin to remember your keybinds and all the other things you want to remember](https://github.com/karimould/zellij-forgot)
  This is awesome when it works, but crashes some times:

- [imsnif/monocle: A Zellij plugin to fuzzy find file names and contents in style 🧐](https://github.com/imsnif/monocle)

I have this installed but haven't been able to make it work:

- [Nacho114/harpoon: Zellij plugin to quickly navigate your panes (clone of nvim's harpoon)](https://github.com/Nacho114/harpoon?tab=readme-ov-file)

## Other interesting plugins

Potentially might want to add in the future.

### Naviation related

#### Tabs

[Strech/zbuffers: Zellij plugin for convenient switching between tabs with search capabilities](https://github.com/Strech/zbuffers)
[rvcas/room: A Zellij plugin for quickly searching and switching tabs 🖤](https://github.com/rvcas/room)

#### Others

- [blank2121/zellij-jump-list: Just like how Vim, Neovim, and Emacs users have a jump list for different navigation, now Zellij users can have that as well!](https://github.com/blank2121/zellij-jump-list)
- [yaroslavborbat/zellij-bookmarks: Zellij plugin for creating, managing, and quickly inserting command bookmarks into the terminal.](https://github.com/yaroslavborbat/zellij-bookmarks)
- [hiasr/vim-zellij-navigator](https://github.com/hiasr/vim-zellij-navigator)

### Related to managing sessions

- [laperlej/zellij-sessionizer](https://github.com/laperlej/zellij-sessionizer)
- [JoseMM2002/zellij-favs: A simple and intuitive plugin for managing favorite sessions in Zellij. Easily organize and switch between sessions with ease.](https://github.com/JoseMM2002/zellij-favs)
- [laperlej/zellij-choose-tree](https://github.com/laperlej/zellij-choose-tree)
