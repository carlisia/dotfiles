local M = {}

M.options = {
	user = function()
		local opt = vim.opt

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
	theme = "onedarker", -- default theme
}

M.plugins = {
	remove = {
		"neovim/nvim-lspconfig",
		"folke/which-key.nvim",
		-- "williamboman/nvim-lsp-installer",
	},
	user = require("custom.plugins"),
}

M.plugins.override = {
	["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
	["windwp/nvim-autopairs"] = { check_ts = true },
	["NvChad/nvim-colorizer.lua"] = require("custom.plugins.common").colorizer(),
	["neovim/nvim-lspconfig"] = require("custom.plugins.common").lspconfig(),
	["ray-x/lsp_signature.nvim"] = require("custom.plugins.common").lsp_signature(),
	["kyazdani42/nvim-tree.lua"] = require("custom.plugins.common").nvimtree(),
	["nvim-treesitter/nvim-treesitter"] = require("custom.plugins.common").treesitter(),
	["nvim-telescope/telescope.nvim"] = require("custom.plugins.common").telescope(),
	["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
}

M.mappings = {
	telescope = require("custom.mappings").telescope,
}

return M
