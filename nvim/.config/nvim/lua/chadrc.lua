--@type ChadrcConfig
local M = {}

local highlights = require "custom_ui.base46"
local ui = require "custom_ui.statusline"

-- Powerful Collection of 68 beautifully crafted themes, extensible and compiled to bytecode
M.base46 = {
  theme = "bearded-arc",
  -- The pair and the default live in utils/theme.lua, out of the theme picker's reach.
  theme_toggle = require("utils.theme").toggle_pair,

  hl_override = highlights.overrides,
}

-- Collection of various ui's like statusline, tabline, dashboard, cheatsheet etc
M.ui = {
  cmp = ui.cmp_ui,
  statusline = ui.statusline,
}

return M
