local M = {}

--- Fetch emoji representing current state
local emoji = require "utils.toggle_states"
function M.current_state_emoji()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Ensure the buffer is valid
  if not vim.api.nvim_buf_is_valid(bufnr) then
    print "❌ Invalid buffer"
    return emoji.inlay_hints[false]
  end

  -- Ensure `is_enabled` function exists
  if not vim.lsp.inlay_hint or not vim.lsp.inlay_hint.is_enabled then
    print "❌ Inlay hints feature not available"
    return emoji.inlay_hints[false]
  end

  -- Check if any LSP server is attached to this buffer
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if #clients == 0 then
    return emoji.inlay_hints[false]
  end

  -- Call `is_enabled()` safely
  local success, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })

  if not success then
    print("❌ Error checking inlay hint state:", is_enabled)
    return emoji.inlay_hints[false]
  end

  return emoji.inlay_hints[is_enabled]
end

return M
