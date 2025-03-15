local M = {}

function M.disable_cmp_in_comments()
  local context = require "cmp.config.context"
  -- leave it enabled in command mode
  if vim.api.nvim_get_mode().mode == "c" then
    return true
  end
  -- disable completion inside comments
  return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
end

--- Manually enable/disable
vim.g.cmptoggle = false
M.toggle = function()
  vim.g.cmptoggle = not vim.g.cmptoggle

  require("cmp").setup {
    enabled = function()
      return vim.g.cmptoggle
    end,
  }
  local status = vim.g.cmptoggle and "enabled" or "disabled"
  vim.notify("AutoComplete " .. status, vim.log.levels.INFO)
end

--- Fetch emoji representing current state
local emoji = require "utils.toggle_states"
function M.current_state_emoji()
  return emoji.autocomplete[vim.g.cmptoggle]
end

return M
