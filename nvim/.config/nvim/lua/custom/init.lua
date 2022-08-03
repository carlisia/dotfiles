-- vim.opt.rtp:append(vim.fn.stdpath "config" .. "/lua/custom/runtime")

require("custom.autocmds").aki()
require("custom.commands").aki()
require("custom.mappings").aki()

local opt = vim.opt
opt.pumheight = 30
opt.tabstop = 4
opt.undofile = false

opt.shell = "/usr/local/bin/bash"

opt.termguicolors = true

vim.o.list = true
opt.listchars:append("space:⋅")
-- vim.o.listchars = { space = "⋅", tab = "⋅" }
--
vim.o.sessionoptions = "blank,buffers,curdir,localoptions,folds,help,tabpages,winsize,winpos,terminal"
