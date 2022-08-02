local M = {}

M.options = {
  nvChad = {
    -- update_url = "https://github.com/carlisia/NvChad",
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "main",
  },
}

M.ui = {
  theme = "onedarker", -- default theme
}

M.plugins = {
  remove = {
    "NvChad/nvterm",
    "folke/which-key.nvim",
    "kyazdani42/nvim-tree.lua",
  },
  user = require("custom.plugins"),
}

M.plugins.override = {
  ["windwp/nvim-autopairs"] = { check_ts = true },
  ["NvChad/nvim-colorizer.lua"] = require("custom.plugins.common").colorizer(),
  ["nvim-treesitter/nvim-treesitter"] = require("custom.plugins.common").treesitter(),
  ["nvim-telescope/telescope.nvim"] = require("custom.plugins.common").telescope(),
  ["NvChad/ui"] = { tabufline = { enabled = false }, statusline = { separator_style = "arrow" } },
}

M.mappings = {
  telescope = require("custom.mappings").telescope,
}

return M
