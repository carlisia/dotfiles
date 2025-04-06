local helper = require "utils.functions"

MiniFiles = MiniFiles

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command
    Snacks.toggle.diagnostics():map "\\p"
    -- Markdown and other filetypes use conceallevel to make text easier to read:
    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 1 }):map "\\v"
    Snacks.toggle.treesitter():map "\\T"
    Snacks.toggle.inlay_hints():map "\\y"
    Snacks.toggle.indent():map "\\I"
    Snacks.toggle.dim():map "\\D"
  end,
})

-- Lint
-- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#usage
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    require("lint").try_lint()
  end,
})

-- Mini explorer / split
-- Create mappings to modify target window via (custom) split
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    helper.map_split(buf_id, "<C-h>", "belowright horizontal")
    helper.map_split(buf_id, "<C-v>", "belowright vertical")
    helper.map_split(buf_id, "<C-t>", "tab")
  end,
})

local set_mark = function(id, path, desc)
  MiniFiles.set_bookmark(id, path, { desc = desc })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesExplorerOpen",
  callback = function()
    set_mark("c", vim.fn.stdpath "config", "Config") -- path
    set_mark("w", vim.fn.getcwd, "Working directory") -- callable
    set_mark("~", "~", "Home directory")
  end,
})

-- Needed to add comments to sql files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.bo.commentstring = "-- %s"
  end,
})

--- LSP
--- reacts to all LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    require("configs.lspconfig_on_attach").on_attach(client, bufnr)
  end,
})
