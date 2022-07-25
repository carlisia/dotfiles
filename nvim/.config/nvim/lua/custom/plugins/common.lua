local M = {}

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
	return "custom.plugins.lspconfig"
end

function M.lsp_signature()
	return {
		doc_lines = 2,
		floating_window_above_cur_line = true,
		-- floating_window_off_x = 10,
		-- floating_window_off_y = 10,
		fix_pos = false,
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
	}
end

return M
