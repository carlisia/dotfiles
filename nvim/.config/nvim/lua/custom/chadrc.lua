local M = {}

local override = require("custom.plugins.override")

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
	theme = "catppuccin",
	theme_toggle = { "onedark", "tokyodark" },
}

M.plugins = {
	remove = {
		"neovim/nvim-lspconfig",
		"folke/which-key.nvim",
		-- "NvChad/nvim-colorizer.lua",
	},

	override = {
		["kyazdani42/nvim-tree.lua"] = override.nvimtree,
		["nvim-treesitter/nvim-treesitter"] = override.treesitter,
		["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
		["windwp/nvim-autopairs"] = { check_ts = true },
		["neovim/nvim-lspconfig"] = override.lspconfig_setup,
		["ray-x/lsp_signature.nvim"] = override.lsp_signature,
		["nvim-telescope/telescope.nvim"] = override.telescope,
		["lewis6991/gitsigns.nvim"] = override.gitsigns,
		["goolord/alpha-nvim"] = override.alpha,

		["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
	},

	user = require("custom.plugins"),
}

-- M.mappings = {
-- 	shade = require("custom.plugins.mappings").shade,
-- 	searchbox = require("custom.plugins.mappings").searchbox,
-- }

M.mappings = require("custom.plugins.mappings")

return M
