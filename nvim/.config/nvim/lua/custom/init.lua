local opt = vim.opt

opt.rtp:append(vim.fn.stdpath("config") .. "/lua/custom/runtime")
opt.pumheight = 30

opt.shell = "/usr/local/bin/bash"
opt.termguicolors = true
opt.list = true
opt.listchars:append("space:⋅")

-- this is for trld so there's no duplicate messages
vim.diagnostic.config({ virtual_text = false })

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

vim.api.nvim_exec([[ autocmd BufWritePre (InsertLeave?) <buffer> lua vim.lsp.buf.formatting_sync(nil,500)]])

vim.defer_fn(function()
	-- Create directory if missing: https://github.com/jghauser/mkdir.nvim
	vim.cmd([[autocmd BufWritePre * lua require('custom.extensions').create_dirs()]])

	-- only enable treesitter folding if enabled
	vim.cmd([[autocmd BufWinEnter * lua require('custom.extensions').enable_folding()]])

	vim.cmd("hi! Folded guifg=#fff")

	vim.cmd("silent! command Sudowrite lua require('custom.extensions').sudo_write()")
end, 0)

local new_cmd = vim.api.nvim_create_user_command

new_cmd("EnableShade", function()
	require("shade").setup()
end, {})

new_cmd("EnableAutosave", function()
	require("autosave").setup()
end, {})

new_cmd("EnableTelescope", function()
	require("telescope").setup()
end, {})

local map = require("utils").map

-- map("n", "<C-h>", "<C-w>h", { noremap = true, silent = false })
-- map("n", "<C-l>", "<C-w>l", { noremap = true, silent = false })
-- map("n", "<C-j>", "<C-w>j", { noremap = true, silent = false })
-- map("n", "<C-k>", "<C-w>k", { noremap = true, silent = false })
--
-- map("i", "jk", "<ESC>", { noremap = true, silent = false })
-- map("i", "kj", "<ESC>", { noremap = true, silent = false })
--
