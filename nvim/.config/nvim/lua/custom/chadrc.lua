---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.options = {
  nvChad = {
    -- update_url = "https://github.com/carlisia/NvChad",
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "v2.0",
  },
}

M.ui = {
  theme = "onedarker", -- preferred theme
  transparency = false,
  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = require("custom.plugins")

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

-- M.mappings = {
--   telescope = require("custom.mappings").telescope,
--   disabled = require("custom.mappings").disabled,
-- }

return M
