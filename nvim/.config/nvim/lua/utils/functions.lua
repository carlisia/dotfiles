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

-- https://github.com/echasnovski/mini.nvim/blob/760c1f3619418f769526884a3de47f0b76245887/doc/mini-files.txt#L417
-- This only create a split (with the same file in the current buffer) and changes target window to be that split.
-- Follow with actually opening a (new) file the usual way.
M.map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
  end

  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

return M
