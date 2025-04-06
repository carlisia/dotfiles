-- Adapted from: https://github.com/desdic/neovim/blob/e22e397238bc8a53e2bbff885992756e99067014/lua/core/format.lua
local toggle_states = {
  autocomplete = {
    [true] = "🔠 ",
    [false] = "⛔ ",
  },
  format_on_save = {
    [true] = "✨ ",
    [false] = "🔕 ",
  },
  inlay_hints = {
    [true] = "🔍  ",
    [false] = "❌ ",
  },
}

local M = {
  -- Filetypes marked to be excluded from autoformat on save (by the toggling)
  excluded_filetypes = {},
}

function M.autoformat_on_save()
  local filetype = vim.o.filetype
  local is_excluded = M.excluded_filetypes[filetype]
  M.excluded_filetypes[filetype] = vim.F.if_nil(not is_excluded, true)
  local state = M.excluded_filetypes[filetype] and "disabled" or "enabled"
  vim.notify("AutoFormat on save for " .. filetype .. " " .. state)
end

--- Check if format-on-save is enabled for current filetype
local function is_format_on_save_enabled()
  local filetype = vim.o.filetype
  return not M.excluded_filetypes[filetype]
end

--- Fetch emoji representing current format-on-save state
function M.autoformat_on_save_emoji()
  return toggle_states.format_on_save[is_format_on_save_enabled()]
end

M.loclist = function()
  vim.schedule(function()
    local is_open = false
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.loclist == 1 then
        is_open = true
        break
      end
    end

    if is_open then
      vim.cmd "lclose"
    else
      -- Populate loclist from diagnostics
      vim.diagnostic.setloclist { open = false } -- don't open yet

      -- Check if we have items
      local loclist = vim.fn.getloclist(0)
      if not vim.tbl_isempty(loclist) then
        vim.cmd "lopen"
      else
        vim.notify("No buffer diagnostics", vim.log.levels.WARN)
      end
    end
  end)
end

M.quickfix = function()
  vim.schedule(function()
    local is_open = false
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
        is_open = true
        break
      end
    end

    if is_open then
      vim.cmd "cclose"
    else
      -- Populate quickfix list from diagnostics
      vim.diagnostic.setqflist { open = false } -- don't open yet

      -- Check if we have items
      local qflist = vim.fn.getqflist()
      if not vim.tbl_isempty(qflist) then
        vim.cmd "copen"
      else
        vim.notify("No workspace diagnostics", vim.log.levels.WARN)
      end
    end
  end)
end

-- Manually enable/disable
vim.g.cmptoggle = true
M.autocomplete = function()
  vim.g.cmptoggle = not vim.g.cmptoggle

  require("cmp").setup {
    enabled = function()
      return vim.g.cmptoggle
    end,
  }
  local status = vim.g.cmptoggle and "enabled" or "disabled"
  vim.notify("AutoComplete " .. status, vim.log.levels.INFO)
end

function M.completion_emoji()
  return toggle_states.autocomplete[vim.g.cmptoggle]
end

--- Fetch emoji representing current state
function M.inlay_emoji()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Ensure the buffer is valid
  if not vim.api.nvim_buf_is_valid(bufnr) then
    print "❌ Invalid buffer"
    return toggle_states.inlay_hints[false]
  end

  -- Ensure `is_enabled` function exists
  if not vim.lsp.inlay_hint or not vim.lsp.inlay_hint.is_enabled then
    print "❌ Inlay hints feature not available"
    return toggle_states.inlay_hints[false]
  end

  -- Check if any LSP server is attached to this buffer
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if #clients == 0 then
    return toggle_states.inlay_hints[false]
  end

  -- Call `is_enabled()` safely
  local success, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })

  if not success then
    print("❌ Error checking inlay hint state:" .. is_enabled)
    return toggle_states.inlay_hints[false]
  end

  return toggle_states.inlay_hints[is_enabled]
end

M.mini_explorer = function()
  if vim.bo.ft == "minifiles" then
    MiniFiles.close()
  else
    local file = vim.api.nvim_buf_get_name(0)
    local file_exists = vim.fn.filereadable(file) ~= 0
    MiniFiles.open(file_exists and file or nil)
    MiniFiles.reveal_cwd()
  end
end

return M
