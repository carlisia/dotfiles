local M = {}

M.treesitter = {
	ensure_installed = {
		"go",
		"json",
		"toml",
		"markdown",
		"c",
		"bash",
		"lua",
		"norg",
		"yaml",
	},
	autopairs = { enable = true },
	context_commentstring = { enable = true },
	highlight = { enable = true, use_languagetree = true },
	matchup = {
		enable = true, -- mandatory, false will disable the whole extension
		disable = { "c", "ruby" }, -- optional, list of language that will be disabled
		-- [options]
	},
}

M.telescope = {
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
		file_ignore_patterns = { "node_modules/", ".git/" },
	},
	exteKnsions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
}

M.lsp_signature = {
	doc_lines = 4,
	floating_window_above_cur_line = true,
	-- floating_window_off_x = 10,
	-- floating_window_off_y = 10,
	fix_pos = false,
}

M.nvimtree = {
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = { "alpha" },
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = false,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = false,
	},
	git = {
		enable = true,
		ignore = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
				folder_arrow = false,
				file = true,
				folder = true,
			},
		},
		indent_markers = { enable = true },
	},
	filters = { exclude = {} },
	view = { hide_root_folder = false, adaptive_size = false },
}

M.gitsigns = {
	signs = {
		add = {
			hl = "GitSignsAdd",
			text = "",
			numhl = "GitSignsAddNr",
			linehl = "GitSignsAddLn",
		},
		change = {
			hl = "GitSignsChange",
			text = "",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
		delete = {
			hl = "GitSignsDelete",
			text = "",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		topdelete = {
			hl = "GitSignsDelete",
			text = "",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		changedelete = {
			hl = "GitSignsChange",
			text = "",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
	},
}

M.alpha = {
	header = {
		val = {
			"         ,_---~~~~~----._         ",
			'  _,,_,*^____      _____``*g*"*, ',
			" / __/ /'     ^.  /      \\ ^@q   f ",
			" [  @f | @))    |  | @))   l  0 _/  ",
			" \\`/  \\~____ / __ \\_____/    \\   ",
			"  |           _l__l_           I   ",
			"           [______]           I  ",
			"  ]            | | |            |  ",
			"  ]             ~ ~             |  ",
			"  |                            |   ",
			"   |                           |   ",
		},
	},

	-- buttons = {
	-- 	{ "SPC f", "  Find File", "<CMD>Telescope find_files<CR>" },
	-- 	{ "SPC n", "  New File", "<CMD>ene!<CR>" },
	-- 	{ "SPC p", "  Recent Projects ", "<CMD>Telescope projects<CR>" },
	-- 	{ "SPC u", "  Recently Used Files", "<CMD>Telescope oldfiles<CR>" },
	-- 	{ "SPC s", "  Load last session", "<CMD>SessionLoad<CR>" },
	-- 	{ "SPC r", "  Ranger", "<CMD>RnvimrToggle<CR>" },
	-- 	{ "SPC m", "  Marks              ", "<CMD>Telescope marks<CR>" },
	-- 	{ "SPC w", "  Find Word", "<CMD>Telescope live_grep<CR>" },
	-- 	{ "SPC c", "  Edit Configuration", "<CMD>e ~/.config/lvim/config.lua<CR>" },
	-- 	{ "SPC g", "  Git status", "<CMD>Telescope git_status<CR>" },
	-- },
}

M.lspconfig_setup = function()
	require("custom.plugins.lspconfig")
end

return M