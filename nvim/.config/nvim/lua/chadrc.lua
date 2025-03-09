--@type ChadrcConfig
local M = {}

local highlights = require "custom.base46"
local ui = require "custom.ui"

M.base46 = {
  theme = "carbonfox",
  theme_toggle = {
    "carbonfox", -- high contrast, heavy on the red
    "oxocarbon", -- same as above, low red
    --- for when tired:
    "neofusion",
    "nightowl",
    ---
    "onedark",
    "one_light",
  },

  hl_override = highlights.overrides,
}

M.ui = {
  cmp = ui.cmpUI,
  statusline = ui.statusline,
}

return M
