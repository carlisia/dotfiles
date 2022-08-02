-- vim.opt.rtp:append(vim.fn.stdpath "config" .. "/lua/custom/runtime")
local opt = vim.opt
opt.pumheight = 30
opt.tabstop = 4
opt.undofile = false

opt.termguicolors = true

vim.o.list = true
vim.o.listchars = { space = "⋅", tab = "⋅" }

-- opt.list = true
-- opt.listchars = { space = "⋅", tab = "⋅" }
--
vim.o.sessionoptions = "blank,buffers,curdir,localoptions,folds,help,tabpages,winsize,winpos,terminal"

require("custom.autocmds").aki()
require("custom.commands").aki()
require("custom.mappings").aki()
