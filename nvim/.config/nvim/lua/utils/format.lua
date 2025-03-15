-- Adapted from: https://github.com/desdic/neovim/blob/e22e397238bc8a53e2bbff885992756e99067014/lua/core/format.lua
local M = {
  -- Preferred defaults
  filetypes = {
    go = true,
    lua = true,
  },
}

--- Manually enable/disable
function M.toggle()
  local filetype = vim.o.filetype
  M.filetypes[filetype] = vim.F.if_nil(not M.filetypes[filetype], false)
  local state = M.filetypes[filetype] and "enabled" or "disabled"
  vim.notify("Autoformat for " .. filetype .. " " .. state)
end

--- Fetch emoji representing current state
local emoji = require "utils.toggle_states"
function M.current_state_emoji()
  local filetype = vim.o.filetype
  local is_enabled = M.filetypes[filetype] or false
  return emoji.format_on_save[is_enabled]
end

--- Lsp formatting
function M.format()
  local buf = vim.api.nvim_get_current_buf()

  local have_conform, conform = pcall(require, "conform")
  if have_conform then
    conform.format {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    }
    return
  end

  vim.lsp.buf.format {
    bufnr = buf,
  }
end

function M.on_attach(_, buf)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
    buffer = buf,
    callback = function()
      if M.filetypes[vim.o.filetype] then
        M.format()
      end
    end,
  })
end

return M
