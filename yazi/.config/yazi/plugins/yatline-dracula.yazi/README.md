# yatline-dracula.yazi

Dracula theme For [yatline.yazi](https://github.com/imsi32/yatline.yazi)

![Dracula](https://draculatheme.com/images/dracula.gif)

## Previews

![headers_drucula](.img/2024-12-29-19-13-50.png)
![status_drucula](.img/2024-12-29-19-18-11.png)

## Requirements

- [yazi](https://github.com/sxyazi/yazi) version >= 0.3.0
- [yatline.yazi](https://github.com/imsi32/yatline.yazi)

## Installation

```sh
ya pack -a wakaka6/yatline-dracula
```

## Usage

> [!IMPORTANT]
> Add this to your `~/.config/yazi/init.lua` before Yatline's initialization.

```lua
local dracula_theme = require("yatline-dracula"):setup()
```

Then use the `theme` variable in Yatline config's theme parameter.

```lua
require("yatline"):setup({
-- ===

	theme = dracula_theme,

-- ===
})
```

## Credits

- [yatline-catppuccin.yazi](https://github.com/imsi32/yatline-catppuccin.yazi)
- [yatline-gruvbox.yazi](https://github.com/imsi32/yatline-gruvbox.yazi)
