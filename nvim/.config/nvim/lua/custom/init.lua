-- vim.opt.rtp:append(vim.fn.stdpath "config" .. "/lua/custom/runtime")
vim.opt.pumheight = 30
vim.opt.tabstop = 4
vim.opt.undofile = false

vim.o.sessionoptions = "blank,buffers,curdir,localoptions,folds,help,tabpages,winsize,winpos,terminal"

require("custom.autocmds").aki()
require("custom.commands").aki()
require("custom.mappings").aki()
