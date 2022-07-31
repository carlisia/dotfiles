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
	theme_toggle = { "onedark", "tokyodark" },
	-- hl_override = require("custom.highlights"),
}

M.plugins = {
	remove = {
		"folke/which-key.nvim",
	},

	override = {
		["kyazdani42/nvim-tree.lua"] = override.nvimtree,
		["nvim-treesitter/nvim-treesitter"] = override.treesitter,
		["max397574/better-escape.nvim"] = { mapping = { "jk", "JK", "Jk" } },
		["windwp/nvim-autopairs"] = { check_ts = true },
		["ray-x/lsp_signature.nvim"] = override.lsp_signature,
		["nvim-telescope/telescope.nvim"] = override.telescope,
		["lewis6991/gitsigns.nvim"] = override.gitsigns,
		["goolord/alpha-nvim"] = override.alpha,

		-- ["NvChad/ui"] = { tabufline = { lazyload = false }, statusline = { separator_style = "arrow" } },
	},

	user = require("custom.plugins"),
}

return M
