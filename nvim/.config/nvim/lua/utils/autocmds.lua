local helper = require "utils.functions"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.api.nvim_create_user_command("CreateOrOpenNote", function(opts)
      local title = opts.args
      if title == "" then
        vim.notify("Please provide a title.", vim.log.levels.WARN)
        return
      end

      local vault_main = vim.env.VAULT_MAIN or ""
      local inbox_dir = vault_main .. "/§ Inbox/"
      local filename = title:gsub("[^A-Za-z0-9 ]", "") .. ".md"
      local path = vim.fn.expand(inbox_dir .. filename)

      if vim.fn.filereadable(path) == 1 then
        vim.notify("Note exists: " .. filename, vim.log.levels.INFO)
        vim.cmd("edit " .. path)
        return
      end

      -- Generate random ID
      local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      local id = ""
      for _ = 1, 8 do
        local rand = math.random(#charset)
        id = id .. charset:sub(rand, rand)
      end
      local full_id = "nvm-" .. id

      -- Make sure inbox directory exists
      vim.fn.mkdir(inbox_dir, "p")

      -- Write frontmatter and title
      local lines = {
        "---",
        "id: " .. full_id,
        "aliases: " .. title,
        "tags: []",
        "---",
        "",
        "# " .. title,
        "",
      }
      vim.fn.writefile(lines, path)

      vim.notify("New note created: " .. filename, vim.log.levels.INFO)
      vim.cmd("edit " .. path)
    end, { nargs = "*" })
  end,
})

-- Mini files
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
