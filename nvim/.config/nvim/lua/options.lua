require "nvchad.options"

-- How to set options from Lua:
-- Use vim.opt only for "list"/"map" like options ('listchars', 'fillchars', etc.) as it has :append() / :remove() methods,
-- and use vim.o for everything else.
-- Using vim.opt for all options is not an error, but vim.o is a more reliable interface.
local option = vim.o
-- local opt = vim.opt
option.cursorlineopt = "both"
