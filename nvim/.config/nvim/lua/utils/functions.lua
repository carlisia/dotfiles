local M = {}

-- MiniFiles
M.map_split = function(buf_id, lhs, direction)
  local ok, MiniFiles = pcall(require, "mini.files")
  if not ok then
    return
  end

  local rhs = function()
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target)
  end

  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. direction })
end

return M
