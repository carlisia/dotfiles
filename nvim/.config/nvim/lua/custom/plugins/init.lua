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
			local cmp = require("cmp")
			cmp.setup.cmdline("/", {
				sources = {
					{ name = "buffer" },
				},
				mapping = cmp.mapping.preset.cmdline({}),
			})
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				mapping = cmp.mapping.preset.cmdline({}),
			})
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
	["glepnir/lspsaga.nvim"] = {
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

	["rcarriga/nvim-notify"] = {},

	["Mofiqul/trld.nvim"] = {
		config = function()
			require("custom.plugins.config.ui").trld()
		end,
	},
	["sindrets/diffview.nvim"] = {},
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
}
-- 	"chentoast/marks.nvim",
-- 	config = function()
-- 		require("marks").setup({
-- 			default_mappings = true,
-- 			signs = true,
-- 		})
-- 	end,
-- },

--
-- {
-- 	"simrat39/symbols-outline.nvim",
-- 	cmd = "SymbolsOutline",
-- },

-- {
-- 	"folke/todo-comments.nvim",
-- 	requires = "nvim-lua/plenary.nvim",
-- 	config = function()
-- 		require("config.util_todo")
-- 	end,
-- },
-- -- UTILS
-- {
-- 	-- Dev docs
-- 	"rhysd/devdocs.vim",
-- },
--
-- -- LANGUAGES
-- {
-- 	"ray-x/go.nvim",
-- 	config = function()
-- 		require("config.lang_go")
-- 	end,
-- },
--
-- { "cuducos/yaml.nvim" },
--
--
--
-- -- GIT

-- {
--   -- https://github.com/ruifm/gitlinker.nvim
--   'ruifm/gitlinker.nvim',
--   requires = 'nvim-lua/plenary.nvim',
--   event = "BufRead",
--   config = function()
--     require("gitlinker").setup {
--       opts = {
--         mappings = "<leader>gy",
--       },
--     }
--   end,
-- },
-- {
--   "pwntester/octo.nvim",
--   event = "BufRead",
--   requires = {
--     'nvim-lua/plenary.nvim',
--     'nvim-telescope/telescope.nvim',
--     'kyazdani42/nvim-web-devicons',
--   },
--   config = function()
--     require('config.git_octo')
--   end
-- },
--   {
--   "anuvyklack/fold-preview.nvim",
--   requires = "anuvyklack/keymap-amend.nvim",
-- },
-- { "mg979/vim-visual-multi" },
