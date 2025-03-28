require "nvchad.options"

-- How to set options from Lua:
-- Use vim.opt only for "list"/"map" like options ('listchars', 'fillchars', etc.) as it has :append() / :remove() methods,
-- and use vim.o for everything else.
-- Using vim.opt for all options is not an error, but vim.o is a more reliable interface.
local option = vim.o
local g = vim.g

option.cursorlineopt = "both"
g.markdown_folding = 1

-- vim.g.vscode_snippets_exclude = { "all" }
require("luasnip.loaders.from_vscode").lazy_load {
  paths = vim.g.vscode_snippets_path or vim.fn.stdpath "config" .. "/snippets",
}

g.root_spec = { "cwd" }
