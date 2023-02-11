require("custom.autocmds").init()
require("custom.commands").init()

local opt = vim.opt
opt.pumheight = 30
opt.tabstop = 4
opt.undofile = false
opt.swapfile = false

opt.shell = "/usr/local/bin/bash"

opt.termguicolors = true

vim.o.list = true
opt.listchars:append("space:⋅")
vim.o.sessionoptions = "blank,buffers,curdir,localoptions,folds,help,tabpages,winsize,winpos,terminal"

vim.g.terminator_runfile_map = {
  markdown = "glow",
  go = "richgo",
  sh = "bash",
}

require("custom.keybindings").init()
