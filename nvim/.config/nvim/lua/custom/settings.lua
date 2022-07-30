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
