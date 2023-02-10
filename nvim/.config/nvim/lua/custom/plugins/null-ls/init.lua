-- no need to touch this file
-- only custom/plugins/null-ls/builtins.lua should be modified ideally
local ok, null_ls = pcall(require, "null-ls")

if not ok then
  return
end

local sources = require("custom.plugins.null-ls.builtins")(null_ls.builtins) or {}

null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    require("custom.utils").setup_lsp_format(client, bufnr)
  end,
})
