local autocmd = vim.api.nvim_create_autocmd
local M = {}

-- non plugin autocmds
function M.aki()
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

function M.cmp()
  autocmd("FileType", {
    pattern = "go",
    callback = function()
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

function M.nvim_go()
  autocmd("FileType", {
    pattern = "go",
    callback = function()
      vim.keymap.set("", "<leader>fm", "<cmd>GoFormat<cr>", { silent = true, buffer = 0 })
    end,
  })
end

return M
