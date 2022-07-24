return {
	["neovim/nvim-lspconfig"] = {
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},
	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null-ls")
		end,
	},
	["ggandor/lightspeed.nvim"] = {
		opt = true,
		config = function()
			require("lightspeed").setup({
				ignore_case = true,
				repeat_ft_with_target_char = true,
			})
		end, 
	},
	["yamatsum/nvim-cursorline"] = {},
	["itspriddle/vim-marked"] = {},
	["mg979/vim-visual-multi"] =  {},
}

