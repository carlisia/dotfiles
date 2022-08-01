require("custom.settings")

-- to set an external theme:
-- - install the theme
-- do `vim.cmd "colorscheme tokyonight" `

vim.defer_fn(function()
	-- Create directory if missing: https://github.com/jghauser/mkdir.nvim
	vim.cmd([[autocmd BufWritePre * lua require('custom.extensions').create_dirs()]])

	-- only enable treesitter folding if enabled
	vim.cmd([[autocmd BufWinEnter * lua require('custom.extensions').enable_folding()]])

	vim.cmd("hi! Folded guifg=#fff")

	vim.cmd("silent! command Sudowrite lua require('custom.extensions').sudo_write()")
end, 0)

local new_cmd = vim.api.nvim_create_user_command
local api = vim.api

new_cmd("EnableShade", function()
	require("shade").setup()
end, {})

new_cmd("EnableAutosave", function()
	require("autosave").setup()
end, {})

new_cmd("EnableTelescope", function()
	require("telescope").setup()
end, {})

local opt = vim.opt

opt.rtp:append(vim.fn.stdpath("config") .. "/lua/custom/runtime")
opt.pumheight = 30

opt.shell = "/usr/local/bin/bash"
opt.termguicolors = true
opt.list = true
opt.listchars:append("space:⋅")

local map = vim.api.nvim_set_keymap

map("n", "<C-h>", "<C-w>h", { noremap = true, silent = false })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = false })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = false })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = false })

map("i", "jk", "<ESC>", { noremap = true, silent = false })
map("i", "kj", "<ESC>", { noremap = true, silent = false })
