-- How to set options from Lua:
-- Use vim.opt only for "list"/"map" like options ('listchars', 'fillchars', etc.) as it has :append() / :remove() methods,
-- and use vim.o for everything else.
-- Using vim.opt for all options is not an error, but vim.o is a more reliable interface.

-- Always show a global status line, where a single status line spans the entire bottom:
local option = vim.o
local opt = vim.opt

option.laststatus = 3
opt.clipboard:append "unnamedplus"
