local M = {}

local override = require("custom.plugins.override")

M.options = {
	nvChad = {
		-- update_url = "https://github.com/carlisia/NvChad",
		update_url = "https://github.com/NvChad/NvChad",
		update_branch = "main",
	},
}

M.ui = {
	theme = "onedarker",
	-- theme = "decay",
	theme_toggle = { "onedark", "tokyodark" },
	-- hl_override = require("custom.highlights"),
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
		-- ["folke/which-key.nvim"] = override.wk,

		["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
	},

	user = require("custom.plugins"),
}

-- M.mappings = require("custom.mappings")

return M
