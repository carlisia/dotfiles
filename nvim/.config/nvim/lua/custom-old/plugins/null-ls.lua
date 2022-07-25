local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	b.formatting.prettierd.with({
		filetypes = { "markdown", "html", "json" },
	}),

	b.formatting.stylua,
	b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
}

-- null_ls.setup({
-- 	debug = true,
-- 	sources = sources,
--   on_attach = function(client, bufnr)
--       if client.resolved_capabilities.document_formatting then
--         local map = vim.keymap.set
--         local buf_k = function(mo, k, c)
--           map(mo, k, c, { buffer = bufnr })
--         end
--         if client.resolved_capabilities.document_formatting then
--           buf_k("n", "<leader>fm", function()
--             vim.lsp.buf.formatting_sync()
--           end)
--           buf_k("v", "<leader>fm", function()
--             vim.lsp.buf.range_formatting()
--           end)
--         end
--
--         vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--           buffer = bufnr,
--           callback = function()
--             vim.lsp.buf.formatting_sync()
--           end, -- Or myvimfun
--         })
--       end
--     end,
-- })

local M = {}
M.setup = function()
  null_ls.setup {
    sources = sources,
    on_attach = function(client, bufnr)
      if client.resolved_capabilities.document_formatting then
        local map = vim.keymap.set
        local buf_k = function(mo, k, c)
          map(mo, k, c, { buffer = bufnr })
        end
        if client.resolved_capabilities.document_formatting then
          buf_k("n", "<leader>fm", function()
            vim.lsp.buf.formatting_sync()
          end)
          buf_k("v", "<leader>fm", function()
            vim.lsp.buf.range_formatting()
          end)
        end

        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.formatting_sync()
          end, -- Or myvimfun
        })
      end
    end,
  }
end

return M
