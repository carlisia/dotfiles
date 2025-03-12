local M = {}

function M.disableOnComment() end

function M.disable_cmp_in_comments()
  local context = require "cmp.config.context"
  -- leave it enabled in command mode
  if vim.api.nvim_get_mode().mode == "c" then
    return true
  end
  -- disable completion inside comments
  return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
end

local emoji = require "utils.toggle_states"
function M.toggle_cmp()
  return emoji.autocomplete[vim.g.cmptoggle]
end

return M
