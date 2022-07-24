local M = {}

local override = require("custom.override")

-- M.options = {
-- 	nvChad = {
-- 		-- update_url = "https://github.com/carlisia/NvChad",
-- 		update_url = "https://github.com/NvChad/NvChad",
-- 		update_branch = "main",
-- 	},
-- }

M.plugins = {
  override = {
    ["kyazdani42/nvim-tree.lua"] = override.nvimtree,
    ["nvim-treesitter/nvim-treesitter"] = override.treesitter,
    ["lukas-reineke/indent-blankline.nvim"] = override.blankline,
    -- ["ray-x/lsp_signature.nvim"] = override.lsp_signature,
    ["lewis6991/gitsigns.nvim"] = override.gitsigns,
  },

  user = require("custom.plugins"),
}

M.ui = {
  theme = "acquarium",
  hl_add = require("custom.highlights").new_hlgroups,
  theme_toggle = { "gruvchad", "gruvbox_light" },
  hl_override = require("custom.highlights").overriden_hlgroups,
  -- tabufline = { lazyload = false },
  -- statusline = { separator_style = "arrow" },
}

-- M.mappings = {
-- 	telescope = require("custom.mappings").telescope,
-- }

M.mappings = require("custom.mappings")

return M
