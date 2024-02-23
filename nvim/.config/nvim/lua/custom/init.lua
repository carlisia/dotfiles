-- Ensure custom modules are loaded correctly
require("custom.autocmds").init()
require("custom.commands").init()

local opt = vim.opt

-- Setting various Neovim options
opt.pumheight = 30
opt.tabstop = 4
opt.undofile = false
opt.swapfile = false
opt.shell = "/opt/homebrew/bin/fish"
opt.termguicolors = true

-- Configure 'listchars' to show spaces as '⋅'
vim.opt.list = true
opt.listchars:append("space:⋅")

-- Session options to enhance session management
opt.sessionoptions = "blank,buffers,curdir,localoptions,folds,help,tabpages,winsize,winpos,terminal"

-- Custom global variable for running specific file types with designated tools
vim.g.terminator_runfile_map = {
  markdown = "glow",
  go = "richgo",
  sh = "fish",
}

-- Load custom keybindings
require("custom.keybindings").init()
