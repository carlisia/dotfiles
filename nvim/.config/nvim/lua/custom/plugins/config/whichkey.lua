local present, wk = pcall(require, "which-key")

if not present then
	vim.notify("which-key not found.")
	return
end

local options = {
	plugins = {
		marks = false,
		registers = false,
		spelling = { enabled = false, suggestions = 20 },
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},
}

local mappings = require("custom.mappings").keys
local opts = { prefix = "<leader>" }
wk.register(mappings, opts)

wk.setup(options)
