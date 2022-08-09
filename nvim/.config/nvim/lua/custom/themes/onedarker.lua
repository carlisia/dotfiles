local M = {}

local od = require("custom.highlights").onedarker

M.base_30 = {
  white = od.cursor_bg,

  black = "#494b51", -- nvim bg, highlights tab background + mode text on status line (this color is not great for that, but ok)
  darker_black = "#161a1e", -- background of floating windows

  grey = od.gray, -- not tree highlight

  red = od.purple,

  green = od.green,
  vibrant_green = od.sign_add,

  blue = od.blue, -- #
  nord_blue = "#ff007c", -- NORMAL bar?
  teal = "#94D2CF",
  folder_bg = "#A3CBE7", -- color of folders

  cyan = od.sign_delete,
  purple = od.orange,
  dark_purple = od.warning_orange,

  baby_pink = "#FFC0EB",
  pink = od.magenta,
  pmenu_bg = "#F8B3CC",

  yellow = od.yellow,
  sun = od.yellow_orange,
  orange = od.orange,

  black2 = "#22262a", -- not tree highlight
  one_bg = "#25292d", -- real bg of onedark
  one_bg2 = "#2a313e", -- highlight of enclosing block text
  -- one_bg3 = "#393d41",
  one_bg3 = "grey", -- "#a6a8a9", -- "grey", -- can't tell (update: one of these is the inner tab symbol)

  grey_fg = "#4b4f53", -- comments and git blame text
  grey_fg2 = "red",
  light_grey = "green",

  line = "#343A40", -- for lines like vertsplit

  statusline_bg = "#22262e",
  lightbg = "#2f3337", -- text of status line
}

M.base_16 = {
  base00 = "#1e222a", -- entire background
  base01 = "#353b45", -- "#85898f", -- "#353b45", -- can't tell (update: one of these is the inner tab symbol)

  base02 = "#3e4451", -- highlight of selected text
  base03 = "#545862", -- "#a9abb0", -- "#545862", -- can't tell  (update: one of these is the inner tab symbol)

  base04 = "yellow",
  base05 = "#abb2bf",
  -- base06 = "#b6bdca",
  base06 = "#be5046",
  base07 = "#61afef",
  base08 = "#c882e7",
  base09 = "#d19a66",
  base0A = "#e5c07b",
  base0B = "#98c379",
  base0C = "#56b6c2",
  base0D = "#61afef",
  base0E = "#ff9e64",
  base0F = "#be5046",
}

vim.opt.bg = "dark"

return M
