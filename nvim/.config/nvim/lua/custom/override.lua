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
	extensions = {
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

M.colorizer = {
	user_default_options = {
		names = false, -- "Name" codes like Blue
		RRGGBBAA = true, -- #RRGGBBAA hex codes
		rgb_fn = true, -- CSS rgb() and rgba() functions
		hsl_fn = true, -- CSS hsl() and hsla() functions
		css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
		css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
		-- Available modes: foreground, background
		mode = "background", -- Set the display mode.
	},
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

return M
