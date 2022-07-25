local M = {}

local override = require "custom.override"

M.options = {
  user = function()
    local opt = vim.opt
    -- local g = vim.g

    opt.tabstop = 4
    opt.undofile = false
  end,

  nvChad = {
    -- update_url = "https://github.com/carlisia/NvChad",
    update_url = "https://github.com/NvChad/NvChad",
    update_branch = "main",
  },
}

M.ui = {
  theme = "tokyodark",
  hl_add = require("custom.highlights").new_hlgroups,
  theme_toggle = { "gruvchad", "gruvbox_light" },
  hl_override = require("custom.highlights").overriden_hlgroups,
}

M.plugins = {
  remove = {
    "neovim/nvim-lspconfig",
    -- "williamboman/nvim-lsp-installer",
  },

  override = {
    ["kyazdani42/nvim-tree.lua"] = override.nvimtree,
    ["nvim-treesitter/nvim-treesitter"] = override.treesitter,
    ["lukas-reineke/indent-blankline.nvim"] = override.blankline,
    -- ["goolord/alpha-nvim"] = override.alpha,
    ["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
    ["windwp/nvim-autopairs"] = { check_ts = true },
    ["NvChad/nvim-colorizer.lua"] = require("custom.plugins.common").colorizer(),
    ["neovim/nvim-lspconfig"] = require("custom.plugins.common").lspconfig(),
    ["ray-x/lsp_signature.nvim"] = require("custom.plugins.common").lsp_signature(),
    ["nvim-telescope/telescope.nvim"] = require("custom.plugins.common").telescope(),
    -- ["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
  },

  user = require "custom.plugins",
}

-- M.mappings = require("custom.-- mappings")
-- M.mappings.telescope = require("custom.mappings").telescope
M.mappings = {
  telescope = require("custom.mappings").telescope,
}

return M
