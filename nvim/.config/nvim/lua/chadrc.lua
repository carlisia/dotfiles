--@type ChadrcConfig
local M = {}

-- Theme and highlights overrides and additions
local highlights = require "custom.highlights"

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
}

M.ui = {
  hl_override = highlights.overrides,
}

return M
