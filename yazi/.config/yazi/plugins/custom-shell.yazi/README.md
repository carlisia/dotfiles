# Custom-shell.yazi

A yazi plugin to open your custom-shell as well as run your command commands through your yazi Shell, and also save your commands to history.
You can choose any shell and customise keybindings to run any command like nvim, lazygit, cowsay, etc. without inputting the command as well!

## Previews

https://github.com/AnirudhG07/custom-shell.yazi/assets/146579014/1cd6ab98-5b79-4ee8-b59a-dbee053edad5

## Requirements

Yazi version 25.2.7 or higher. And of course, your custom-shell as default shell.

# Installation

```bash
ya pack -a AnirudhG07/custom-shell

## For linux and MacOS
git clone https://github.com/AnirudhG07/custom-shell.yazi.git ~/.config/yazi/plugins/custom-shell.yazi

## For Windows
git clone https://github.com/AnirudhG07/custom-shell.yazi.git %AppData%\yazi\config\plugins\custom-shell.yazi
```

Windows user's should check the init.lua file to make sure the paths used are correct.

# Usage

## History Setup

Add the following to your `init.lua` file:

```lua
require("custom-shell"):setup({
    history_path = "default",
    save_history = true,
})
```

The `default` corresponds to `yazi_cmd_history` file in your `~/.config/yazi/plugins/custom-shell.yazi` directory(and similar for Windows). You can specify any other path if you like to save the history file elsewhere.

The `save_history` option is set to `true` by default, which will enable files to be saved to history. You can disable the behavior by setting it to `false`.

## Shell Selection

There are 2 ways you can set your custom-shell.

- The `auto` mode automatically sets the custom-shell to the value of `$SHELL` environment variable.
- The `shell_name` sets the custom-shell to the shell you want to use.

| **Mode** | **Description**                           |
| -------- | ----------------------------------------- |
| `auto`   | Automatically set custom-shell = `$SHELL` |
| `zsh`    | Set custom-shell = `zsh`                  |
| `bash`   | Set custom-shell = `bash`                 |
| `fish`   | Set custom-shell = `fish` <°))><          |
| `ksh`    | Set custom-shell = `ksh` or Kornshell     |

Similarly you can input the name of the shell you want to use.
<br>
These commands uses the below command to run the shells-

```bash
custom_shell -ic "command";exit
```

You can also set options about the processes to run. The `shell` API for yazi allows the following options:

1. Interactive: default set to `false`.
2. Block: default set to `false`.
3. Orphan: default set to `false`.

To change these options, you can give the following arguments to the plugin:

- To set to `true`, add `--option=true` or simply `--option`.
- To set to `false`, add `--option=false` or simply not add it in the command(unless default is `true`).

For example:

- `--block=false` to set block to false.
- `--orphan=true` to set orphan to true.

Check the keybindings below to see how to set these options.

You can also add `--wait`(default `false`) to make it wait for the user to press return key after executing the command. This allows the command output not to disappear immediately after exit and to stay readable on screen. Note that it is up to the command you run to decide whether to wait for user input or not, so this option may or may not be needed.

![wait argument demo](.assets/wait_demo.gif)

### Keybindings for Custom Shell

Add this to your `keymap.toml` file:

To use the `auto` mode, you can set the keymappings as:

```toml
[[manager.prepend_keymap]]
on = [ "<keybinding>" ]
run = 'plugin custom-shell -- auto --interactive'
desc = "custom-shell as default"
```

To choose a specific shell, you can set the keymappings as:

```toml
[[manager.prepend_keymap]]
on = [ "<keybinding>" ]
run = 'plugin custom-shell zsh' # OR 'plugin custom-shell -- zsh'
desc = "custom-shell as default"
```

To set extra shell arguments, you can add them as:

```toml
[[manager.prepend_keymap]]
on = [ "<keybinding>" ]
run = 'plugin custom-shell -- zsh --interactive --block'
desc = "custom-shell as default with specified arguments"
```

To choose a specific shell(or `auto`) and `wait` for user to press return key after executing the command:

```toml
[[manager.prepend_keymap]]
on = [ "<keybinding>" ]
run = "plugin custom-shell -- zsh --wait"
desc = "custom-shell as default, waits for user"
```

You can input any shell with their shortnames or full names like "Powershell" or "pwsh", "nushell" or "nu", "Kornshell" or "ksh", etc.

### Recommended Keybindings

```toml
[[manager.prepend_keymap]]
on = [ "'", ";" ]
run = 'plugin custom-shell -- auto --interactive'
desc = "custom-shell as default, interactive"
```

```toml
[[manager.prepend_keymap]]
on = [ "'", ":" ]
run = 'plugin custom-shell -- auto --interactive --block'
desc = "custom-shell as default, interactive, block"
```

## Custom Commands

Custom-shell.yazi allows you to run your custom commands without inputting them inside yazi. You can set the shell through which you want to run your command as well. This also supports aliases.

To run a command, you can set the keymappings as:

```toml
[[manager.prepend_keymap]]
on = [ "l", "g" ]
run = "plugin custom-shell -- custom auto lazygit"
desc = "Run lazygit"
```

You can also run the commands with extra arguments as:

```toml
[[manager.prepend_keymap]]
on = [ "'", "1" ]
run = "plugin custom-shell -- custom fish 'echo hi' --orphan"
desc = "Run echo hi"
```

```toml
[[manager.prepend_keymap]]
on = [ "'", "2" ]
run = "plugin custom-shell -- custom nu 'tmux'"
desc = "Run tmux"
```

To make the shell wait for your `ls` command, you can set the keymappings as:

```toml
[[manager.prepend_keymap]]
on = [ "'", "3" ]
run = "plugin custom-shell -- custom zsh 'ls' --wait"
desc = "Run ls"
```

## History

Custom-shell saves the command you have run in a history file. It uses `fzf` to show history and run the selected command. You can set the keymappings to view the history as -

```toml
[[manager.prepend_keymap]]
on = [ "'", "h" ]
run = "plugin custom-shell history"
desc = "Show Custom-shell history"
```

## Features

- Open your custom-shell as your default shell like zsh, <°))>< fish, bash, etc.
- Usage of aliases is supported.
- When using 'auto' mode, if you change your default shell, it will automatically change the custom-shell to the new default shell.
- If your shell runs extra commands like printing texts, taskwarrior, newsupdates, etc. when you open the shell, they will not hinder into it's functioning.
- Run custom commands without inputting them inside yazi.
- Set extra arguments for the processes to run.
- Save commands to history and execute them again.

## Explore Yazi

Yazi is an amazing, blazing fast terminal file manager, with a variety of plugins, flavors and themes. Check them out at [awesome-yazi](https://github.com/AnirudhG07/awesome-yazi) and the official [yazi webpage](https://yazi-rs.github.io/).

## Acknowledgement

This code is referenced from issue [#1206](https://github.com/sxyazi/yazi/issues/1206) and PR [#84](https://github.com/yazi-rs/yazi-rs.github.io/pull/84) I raised on the repositories. Thank you to the maintainers of sxyazi/yazi for the help.
