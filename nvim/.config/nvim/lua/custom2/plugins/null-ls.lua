local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local b = null_ls.builtins

local sources = {
  -- webdev stuff
  b.formatting.deno_fmt,
  b.formatting.prettier.with({
    filetypes = { "html", "markdown", "css" },
    extra_args = { "--single-quote", "false" },
  }),

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

  b.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),

  b.formatting.goimports,
  b.formatting.gofumpt,
  b.code_actions.shellcheck,
}
-- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
null_ls.setup({
  debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_command([[augroup Format]])
      vim.api.nvim_command([[autocmd! * <buffer>]])
      vim.api.nvim_command([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
      vim.api.nvim_command([[augroup END]])
    end
    require("custom.plugins.lsputils").custom_lsp_attach(client, bufnr)
  end,
})
