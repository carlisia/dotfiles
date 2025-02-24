--@type ChadrcConfig
local M = {}

-- Theme and highlights overrides and additions
local highlights = require "custom.highlights"

M.base46 = {
  theme = "decay",
  theme_toggle = { "decay", "onedark", "one_light" },
}

M.ui = {
  hl_override = highlights.overrides,
}

return M
