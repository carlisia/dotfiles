-- https://github.com/Mofiqul/trld.nvim
require("trld").setup({
	-- where to render the diagnostics. 'top' | 'bottom'
	position = "top",

	-- if this plugin should execute it's builtin auto commands
	auto_cmds = true,

	-- diagnostics highlight group names
	highlights = {
		error = "DiagnosticFloatingError",
		warn = "DiagnosticFloatingWarn",
		info = "DiagnosticFloatingInfo",
		hint = "DiagnosticFloatingHint",
	},
	formatter = function(diag)
		local u = require("trld.utils")
		local diag_lines = {}

		for line in diag.message:gmatch("[^\n]+") do
			line = line:gsub("[ \t]+%f[\r\n%z]", "")
			table.insert(diag_lines, line)
		end

		local lines = {}
		for _, diag_line in ipairs(diag_lines) do
			table.insert(lines, { { diag_line .. " ", u.get_hl_by_serverity(diag.severity) } })
		end

		return lines
	end,
})
