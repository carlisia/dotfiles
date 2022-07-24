return {
	-- ["max397574/better-escape.nvim"] = {
	-- 	config = function()
	-- 		require("better_escape").setup({
	-- 			mapping = { "jk", "JK", "Jk" },
	-- 		})
	-- 	end,
	-- },
	-- ["stevearc/dressing.nvim"] = {
	-- 	opt = true,
	-- },
	-- ["kevinhwang91/nvim-bqf"] = { ft = "qf" },
	-- ["folke/trouble.nvim"] = {
	-- 	module = "trouble",
	-- 	requires = "kyazdani42/nvim-web-devicons",
	-- 	config = function()
	-- 		require("trouble").setup({
	-- 			auto_close = true, -- automatically close the list when you have no diagnostics
	-- 			use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
	-- 		})
	-- 	end,
	-- },
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
	-- ["folke/lua-dev.nvim"] = { ft = "lua" },
	-- ["nacro90/numb.nvim"] = {
	-- 	event = "CmdlineEnter",
	-- 	config = function()
	-- 		require("numb").setup()
	-- 	end,
	-- },
	-- ["hrsh7th/cmp-cmdline"] = {
	-- 	after = "nvim-cmp",
	-- 	config = function()
	-- 		local cmp = require("cmp")
	-- 		cmp.setup.cmdline("/", {
	-- 			sources = {
	-- 				{ name = "buffer" },
	-- 			},
	-- 			mapping = cmp.mapping.preset.cmdline({}),
	-- 		})
	-- 		cmp.setup.cmdline(":", {
	-- 			sources = cmp.config.sources({
	-- 				{ name = "path" },
	-- 			}, {
	-- 				{ name = "cmdline" },
	-- 			}),
	-- 			mapping = cmp.mapping.preset.cmdline({}),
	-- 		})
	-- 	end,
	-- },
	["ggandor/lightspeed.nvim"] = {
		opt = true,
		config = function()
			require("lightspeed").setup({
				ignore_case = true,
				repeat_ft_with_target_char = true,
			})
		end,
	},
	-- ["VonHeikemen/searchbox.nvim"] = {
	-- 	module = "searchbox",
	-- 	command = "SearchBox",
	-- 	requires = {
	-- 		{ "MunifTanjim/nui.nvim" },
	-- 	},
	-- 	setup = function()
	-- 		require("custom.mappings").searchbox()
	-- 	end,
	-- },
	-- ["windwp/nvim-spectre"] = {
	-- 	module = "spectre",
	-- 	command = "FindReplace",
	-- 	config = function()
	-- 		require("spectre").setup({
	-- 			color_devicons = true,
	-- 			open_cmd = "new",
	-- 			is_insert_mode = true,
	-- 		})
	-- 	end,
	-- 	setup = function()
	-- 		vim.cmd('silent! command FindReplace lua require("spectre").open({})')
	-- 	end,
	-- },
	-- EDITOR
	-- get highlight group under cursor
	-- ["nvim-treesitter/playground"] = {
	-- 	cmd = "TSCaptureUnderCursor",
	-- 	config = function()
	-- 		require("nvim-treesitter.configs").setup()
	-- 	end,
	-- },
	["yamatsum/nvim-cursorline"] = {
	},
	["itspriddle/vim-marked"] = {
	},
	["mg979/vim-visual-multi"] = {
	},
	-- GIT
}
