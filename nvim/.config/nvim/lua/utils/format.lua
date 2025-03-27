-- Adapted from: https://github.com/desdic/neovim/blob/e22e397238bc8a53e2bbff885992756e99067014/lua/core/format.lua

local M = {
  -- Filetypes to exclude from autoformat on save as the default (without toggling)
  excluded_filetypes = {},
}

function M.toggle()
  local filetype = vim.o.filetype
  local is_excluded = M.excluded_filetypes[filetype]
  M.excluded_filetypes[filetype] = vim.F.if_nil(not is_excluded, true)
  local state = M.excluded_filetypes[filetype] and "disabled" or "enabled"
  vim.notify("AutoFormat on save for " .. filetype .. " " .. state)
end

--- Check if format-on-save is enabled for current filetype
function M.is_enabled()
  local filetype = vim.o.filetype
  return not M.excluded_filetypes[filetype]
end

--- Fetch emoji representing current format-on-save state
local emoji = require "utils.toggle_states"
function M.current_state_emoji()
  return emoji.format_on_save[M.is_enabled()]
end

--- LSP formatting
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

--- Autoformat on save unless excluded
function M.on_attach(_, buf)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
    buffer = buf,
    callback = function()
      if not M.excluded_filetypes[vim.o.filetype] then
        M.format()
      end
    end,
  })
end

return M
