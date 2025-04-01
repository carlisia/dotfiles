--@type ChadrcConfig
local M = {}

local highlights = require "custom_ui.base46"
local ui = require "custom_ui.statusline"

-- Powerful Collection of 68 beautifully crafted themes, extensible and compiled to bytecode
M.base46 = {
  theme = "catppuccin",
  theme_toggle = {
    "catppuccin",
    "default-light",
  },

  hl_override = highlights.overrides,
}

-- Collection of various ui's like statusline, tabline, dashboard, cheatsheet etc
M.ui = {
  cmp = ui.cmp_ui,
  statusline = ui.statusline,
}

return M
