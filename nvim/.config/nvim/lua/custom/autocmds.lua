local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local M = {}

-- non plugin autocmds
function M.init()
  autocmd("FileType", {
    pattern = "qf",
    callback = function()
      vim.keymap.set("", "q", "<cmd>:close<cr>", { silent = true, buffer = 0 })
    end,
  })

  -- Create directory if missing: https://github.com/jghauser/mkdir.nvim
  autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      require("custom.utils").create_dirs()
    end,
  })
end

function M.lsp_autosave_format(bufnr)
  local id = augroup("LspFormatSave_aki", { clear = false })
  local i = vim.api.nvim_get_autocmds({ group = id, event = "BufWritePre", buffer = bufnr })
  if not vim.tbl_isempty(i) then
    return
  end

  autocmd({ "BufWritePre" }, {
    group = id,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

function M.cmp()
  autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.keymap.set("", "<leader>fm", "<cmd>GoFmt<cr>", { silent = true, buffer = 0 })
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.setup.filetype({ "go" }, {
          -- gopls preselects items which I don't like.
          preselect = cmp.PreselectMode.None,
          sorting = {
            -- IMO these comparator settings work better with gopls.
            comparators = {
              cmp.config.compare.length,
              cmp.config.compare.locality,
              cmp.config.compare.sort_text,
            },
          },
        })
      else
        vim.notify("Nvim CMP not loaded", "Error")
      end
    end,
    once = true,
  })
end

function M.null_ls(bufnr)
  autocmd({ "BufWritePre" }, {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.formatting_seq_sync({}, 300)
    end,
  })
end

function M.treesitter()
  autocmd({ "FileType" }, {
    callback = function()
      local char = vim.fn.wordcount()["chars"]
      -- manually disable/enable treesitter after a buffer is created
      if char < 500000 then
        vim.cmd([[silent! TSBufEnable highlight]])
        vim.cmd([[silent! TSBufEnable indent]])
        vim.cmd([[silent! TSBufEnable matchup]])
      else
        vim.cmd([[silent! TSBufDisable highlight]])
        vim.cmd([[silent! TSBufDisable indent]])
        vim.cmd([[silent! TSBufDisable matchup]])
      end
    end,
  })
end

return M
