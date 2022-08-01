local M = {}

function M.bufferline()
	require("custom.plugins.bufferline")
end

function M.cmp()
	require("custom.plugins.cmp_cmdline")
end

function M.colorizer()
	return {
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
end

function M.lspconfig()
	require("custom.plugins.lspconfig")
end

function M.lsp_signature()
	require("lsp_signature").setup({
		bind = false,
		handler_opts = {
			border = "rounded",
		},
		max_width = 80,
		max_height = 4,
		-- doc_lines = 4,
		floating_window = true,

		floating_window_above_cur_line = true,
		fix_pos = false,
		always_trigger = false,
		zindex = 40,
		timer_interval = 100,
	})
end

function M.null_ls()
	require("custom.plugins.null-ls")
end

function M.nvim_go()
	require("go").setup({
		-- notify: use nvim-notify
		notify = true,
		-- lint_prompt_style: qf (quickfix), vt (virtual text)
		lint_prompt_style = "virtual_text",
		-- formatter: goimports, gofmt, gofumpt
		formatter = "gofumpt",
		-- maintain cursor position after formatting loaded buffer
		maintain_cursor_pos = true,
	})
	require("custom.autocmds").nvim_go()
end

function M.nvimtree()
	return {
		filters = { exclude = {} },
		view = { hide_root_folder = false, adaptive_size = false },
		renderer = { indent_markers = { enable = true }, icons = { show = { folder_arrow = false } } },
	}
end

function M.persisted()
	require("persisted").setup({
		autoload = true, -- automatically load the session for the cwd on Neovim startup
		allowed_dirs = { "~" },
		-- https://github.com/rmagatti/auto-session/issues/64#issuecomment-1111409078
		before_save = function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config_ = vim.api.nvim_win_get_config(win)
				if config_.relative ~= "" then
					vim.api.nvim_win_close(win, false)
				end
			end
			vim.cmd(":silent! NvimTreeClose")
			vim.cmd(":silent! Neotree close")
		end,
	})
end

function M.treesitter()
	return {
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
			"vim",
		},
		-- autopairs = { enable = true },
		-- context_commentstring = { enable = true },
		highlight = { enable = true, use_languagetree = true },
		indent = { enable = true },
		matchup = { enable = true },
		tree_docs = { enable = true },
	}
end

function M.telescope()
	return {
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
		extension_list = { "fzf", "notify", "persisted", "neoclip" },
	}
end

function M.toggleterm()
	require("toggleterm").setup({
		-- size can be a number or function which is passed the current terminal
		size = function(term)
			if term.direction == "horizontal" then
				local height = vim.api.nvim_win_get_height(0)
				return (height < 10 and height) or (height * 0.8)
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		-- i basically wanted to disable the mapping so lets use a russian alphabet
		open_mapping = [[д]],
		direction = "horizontal",
	})
end

return M
