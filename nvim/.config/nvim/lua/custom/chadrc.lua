local M = {}

local override = require("custom.override")

M.options = {
	user = function()
		local opt = vim.opt
		-- opt.termguicolors = true
		-- local g = vim.g

		-- for sparkly dots in the indentation space
		opt.list = true
		opt.listchars:append("space:⋅")
		opt.listchars:append("eol:↴")

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
	theme = "ayu-dark",
	theme_toggle = { "onedark", "tokyodark" },
}

M.plugins = {
	remove = {
		"lukas-reineke/indent-blankline.nvim",
		"neovim/nvim-lspconfig",
		-- "williamboman/nvim-lsp-installer",
	},

	override = {
		["kyazdani42/nvim-tree.lua"] = override.nvimtree,
		["nvim-treesitter/nvim-treesitter"] = override.treesitter,
		-- ["goolord/alpha-nvim"] = override.alpha,
		["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
		["windwp/nvim-autopairs"] = { check_ts = true },
		["neovim/nvim-lspconfig"] = require("custom.plugins.common").lspconfig_setup(),
		["ray-x/lsp_signature.nvim"] = override.lsp_signature,
		["nvim-telescope/telescope.nvim"] = override.telescope,

		["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
	},

	user = require("custom.plugins"),
}

M.mappings = require("custom.mappings")
-- M.mappings.telescope = require("custom.mappings").telescope
-- M.mappings

return M
