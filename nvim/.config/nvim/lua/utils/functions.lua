vim.cmd [[
hi! MiniHipatternsCustDone guifg=#000000 guibg=#00CC00 gui=bold
hi! MiniHipatternsCustNote guifg=#FF4000 guibg=#FFFF00 gui=bold
]]

local M = {}

-- Check if a Quickfix or Location List window is open
local function qf_or_loc_exists()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      return true
    end
  end
  return false
end

M.toggle_quickfix = function()
  if qf_or_loc_exists() then
    print "Quickfix or Location List is open. Closing..."

    -- Try closing Quickfix List first
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd "cclose"
      print "Closed Quickfix List"
      return
    end

    -- If Quickfix didn't close, try closing Location List
    if not vim.tbl_isempty(vim.fn.getloclist(0)) then
      vim.cmd "lclose"
      print "Closed Location List"
      return
    end

    return
  end

  -- If neither are open, open Quickfix or Location List based on which has data
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    print "Quickfix has entries. Opening..."
    vim.cmd "copen"
  elseif not vim.tbl_isempty(vim.fn.getloclist(0)) then
    print "Location List has entries. Opening..."
    vim.cmd "lopen"
  else
    print "Neither Quickfix nor Location List have entries!"
  end
end

-- NvChad terminal
local term = require "nvchad.term"
M.toggle_floating_term = function()
  term.toggle { pos = "float", id = "floatTerm" }
end
M.toggle_vertical_term = function()
  term.toggle { pos = "vsp", id = "vtoggleTerm" }
end
M.tggle_horizontal_term = function()
  term.toggle { pos = "sp", id = "htoggleTerm" }
end

-- Mini explorer
M.toggle_mini_explorer = function()
  local minifiles = require "mini.files"
  if vim.bo.ft == "minifiles" then
    minifiles.close()
  else
    local file = vim.api.nvim_buf_get_name(0)
    local file_exists = vim.fn.filereadable(file) ~= 0
    minifiles.open(file_exists and file or nil)
    minifiles.reveal_cwd()
  end
end

-- [mini.nvim/doc/mini-files.txt at c78332b4c71ad3c2a09efe6acd0a51283627258f · echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim/blob/c78332b4c71ad3c2a09efe6acd0a51283627258f/doc/mini-files.txt#L473-L503)
-- Create mappings to modify target window via split
-- This only create a split and changes target window to be that split. Follow with actually opening a file the usual way.
M.map_split = function(buf_id, lhs, direction)
  local rhs = function()
    local minifiles = require "mini.files"
    -- Make new window and set it as target
    local cur_target = minifiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    minifiles.set_target_window(new_target)
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

--- Add custom text for highlighting comments
M.insert_done_comment = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " DONE: " })
end

M.insert_fix_comment = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " FIX: " })
end

M.insert_hack_comment = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " HACK: " })
end

M.insert_note_comment = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " NOTE: " })
end

M.insert_todo_comment = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " TODO: " })
end

return M
