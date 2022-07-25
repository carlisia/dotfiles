local M = {}

local override = require("custom.override")

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
	theme = "ayu-dark",
	theme_toggle = { "onedark", "tokyodark" },
}

M.plugins = {
	remove = {
		"neovim/nvim-lspconfig",
	},

	override = {
		["kyazdani42/nvim-tree.lua"] = override.nvimtree,
		["nvim-treesitter/nvim-treesitter"] = override.treesitter,
		["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
		["windwp/nvim-autopairs"] = { check_ts = true },
		["neovim/nvim-lspconfig"] = require("custom.plugins.common").lspconfig_setup(),
		["ray-x/lsp_signature.nvim"] = override.lsp_signature,
		["nvim-telescope/telescope.nvim"] = override.telescope,
		["lukas-reineke/indent-blankline.nvim"] = override.indentline,
		["lewis6991/gitsigns.nvim"] = override.gitsigns,
		["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
	},

	user = require("custom.plugins"),
}

M.mappings = require("custom.mappings")

return M
