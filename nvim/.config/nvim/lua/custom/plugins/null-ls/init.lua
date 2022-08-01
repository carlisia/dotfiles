-- no need to touch this file
-- only custom/plugins/null-ls/builtins.lua should be modified ideally
local ok, null_ls = pcall(require, "null-ls")

if not ok then
  return
end

local sources = require "custom.plugins.null-ls.builtins"(null_ls.builtins) or {}

null_ls.setup {
  sources = sources,
  on_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then
      local buf_k = function(mo, k, c)
        vim.keymap.set(mo, k, c, { buffer = bufnr })
      end
      if client.resolved_capabilities.document_formatting then
        buf_k("n", "<leader>fm", function()
          vim.lsp.buf.formatting {}
        end)
        buf_k("v", "<leader>fm", function()
          vim.lsp.buf.range_formatting()
        end)

        require("custom.autocmds").null_ls(bufnr)
      end
    end
  end,
}
