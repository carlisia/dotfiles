return {
	["max397574/better-escape.nvim"] = {
		config = function()
			require("better_escape").setup({
				mapping = { "jk", "JK", "Jk" },
			})
		end,
	},
	["stevearc/dressing.nvim"] = {
		opt = true,
		setup = function()
			require("custom.extensions").packer_lazy_load("dressing.nvim")
		end,
	},

	["kevinhwang91/nvim-bqf"] = { ft = "qf" },

	["folke/trouble.nvim"] = {
		module = "trouble",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				auto_close = true, -- automatically close the list when you have no diagnostics
				use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
			})
		end,
	},
	["neovim/nvim-lspconfig"] = {
		opt = true,
		module = "lspconfig",
		config = function()
			require("custom.plugins.lspconfig")
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("nvim-lspconfig")
			-- reload the current file so lsp actually starts for it
			vim.defer_fn(function()
				vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
			end, 0)
		end,
	},
	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null-ls").setup()
		end,
	},
	["folke/lua-dev.nvim"] = { ft = "lua" },
	["nacro90/numb.nvim"] = {
		event = "CmdlineEnter",
		config = function()
			require("numb").setup()
		end,
	},
	["nvim-telescope/telescope-fzf-native.nvim"] = {
		run = "make",
		after = "telescope.nvim",
		config = function()
			require("telescope").load_extension("fzf")
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("telescope.nvim")
		end,
	},
	["hrsh7th/cmp-cmdline"] = {
		after = "nvim-cmp",
		config = function()
			require("custom.plugins.config.editor").cmp()
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("nvim-cmp")
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
		setup = function()
			require("custom.extensions").packer_lazy_load("lightspeed.nvim")
		end,
	},
	["VonHeikemen/searchbox.nvim"] = {
		module = "searchbox",
		command = "SearchBox",
		requires = {
			{ "MunifTanjim/nui.nvim" },
			config = function()
				require("searchbox").setup()
			end,
		},
	},
	["windwp/nvim-spectre"] = {
		module = "spectre",
		command = "FindReplace",
		config = function()
			require("spectre").setup({
				color_devicons = true,
				open_cmd = "new",
				is_insert_mode = true,
			})
		end,
		setup = function()
			vim.cmd('silent! command FindReplace lua require("spectre").open({})')
		end,
	},
	--- EDITOR
	["itspriddle/vim-marked"] = {
		setup = function()
			require("custom.extensions").packer_lazy_load("vim-marked")
		end,
	},
	["mg979/vim-visual-multi"] = {
		setup = function()
			require("custom.extensions").packer_lazy_load("vim-visual-multi")
		end,
	},
	["goolord/alpha-nvim"] = {
		disable = false,
		cmd = "Alpha",
	},
	["kkharji/lspsaga.nvim"] = {
		config = function()
			require("custom.plugins.config.ui").lspsaga()
		end,
	},
	-- dim inactive windows
	["andreadev-it/shade.nvim"] = {
		module = "shade",
		config = function()
			require("custom.plugins.config.ui").shade()
		end,
	},
	["Pocco81/AutoSave.nvim"] = {
		module = "autosave",
		config = function()
			require("custom.plugins.config.ui").autosave()
		end,
	},

	["rcarriga/nvim-notify"] = {
		after = "telescope.nvim",
		config = function()
			require("custom.plugins.config.ui").notify()
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("telescope.nvim")
		end,
	},

	["Mofiqul/trld.nvim"] = {
		config = function()
			require("custom.plugins.config.ui").trld()
		end,
	},

	["sindrets/diffview.nvim"] = {
		-- TODO: fix the setup
		-- config = function()
		-- 	require("custom.plugins.config.diffview")
		-- end,
		-- setup = function()
		-- 	require("custom.extensions").packer_lazy_load("diffview.nvim")
		-- end,
	},

	["nvim-telescope/telescope-project.nvim"] = {
		event = "BufWinEnter",
		-- config = function()
		-- 	vim.cmd([[packadd telescope.nvim]])
		-- end,
	},
	["f-person/git-blame.nvim"] = {
		event = "BufRead",
		config = function()
			vim.cmd("highlight default link gitblame SpecialComment")
			vim.g.gitblame_enabled = 0
		end,
	},

	["tpope/vim-fugitive"] = {},

	["andymass/vim-matchup"] = {},

	["liuchengxu/vim-clap"] = {
		command = ":Clap install-binary!",
		config = function()
			require("custom.plugins.config.ui").clap()
		end,
	},
	["folke/todo-comments.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("custom.plugins.config.todo")
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("todo-comments.nvim")
		end,
	},
	["folke/which-key.nvim"] = {
		after = "telescope.nvim",
		config = function()
			require("custom.plugins.config.whichkey")
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("which-key.nvim")
		end,
	},
	["ruifm/gitlinker.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		event = "BufRead",
		config = function()
			require("gitlinker").setup({
				opts = {
					mappings = "<leader>gy",
				},
			})
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("gitlinker.nvim")
		end,
	},
	["akinsho/toggleterm.nvim"] = {
		tag = "v2.*",
		config = function()
			require("toggleterm").setup()
		end,
		setup = function()
			require("custom.extensions").packer_lazy_load("toggleterm.nvim")
		end,
	},
	-- TODO: CHANGE THEME
}