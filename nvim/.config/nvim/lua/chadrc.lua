--@type ChadrcConfig
local M = {}

-- Theme and highlights overrides and additions
local highlights = require "custom.highlights"

M.base46 = {
  theme = "decay",
}

M.ui = {
  hl_override = highlights.overrides,
}

return M
