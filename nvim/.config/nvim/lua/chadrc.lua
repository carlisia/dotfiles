-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

-- This file `lua/chadrc.lua` is user's config file used to customize Base46 & UI plugin and it needs to return a table.

---@type ChadrcConfig
local M = {}

M.base46 = {
	-- theme = "aquarium",
	theme = "ayu_dark",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },


}

M.ui = {
	statusline = {
	-- theme: ~
	-- |values| = default, vscode, vscode_colored, minimal
	-- separator_style: ~
	-- |values| = default, round, block, arrow
	-- Note: the style wont work for vscode themes
		theme = "default",
		separator_style = "default",
  },
-- // default = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
-- // vscode = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd" },
--   order = { "mode", "f", "git", "%=", "lsp_msg", "%=", "lsp", "cwd"},

}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
