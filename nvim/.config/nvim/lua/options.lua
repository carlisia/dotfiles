require "nvchad.options"

-- How to set options from Lua:
-- Use vim.opt only for "list"/"map" like options ('listchars', 'fillchars', etc.) as it has :append() / :remove() methods,
-- and use vim.o for everything else.
-- Using vim.opt for all options is not an error, vim.o is a more reliable interface.

-- ╭─────────────────────────────────────────────────────────╮
-- │ Mini                                                    │
-- ╰─────────────────────────────────────────────────────────╯
-- [mini.nvim/doc/mini-files.txt at c78332b4c71ad3c2a09efe6acd0a51283627258f · echasnovski/mini.nvim](https://github.com/echasnovski/mini.nvim/blob/c78332b4c71ad3c2a09efe6acd0a51283627258f/doc/mini-files.txt#L473-L503)
-- Create mappings to modify target window via split
-- This only create a split and changes target window to be that split. Follow with actually opening a file the usual way.
local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

-- mini starter
-- At startup, auto open MiniStarter if no files are opened
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local has_mini, MiniStarter = pcall(require, "mini.starter")
    if has_mini and vim.fn.argc() == 0 then
      MiniStarter.open()
    end
  end,
})

-- Auto open MiniStarter when the last buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local listed_bufs = vim.t.bufs or {}
    if #listed_bufs == 1 and vim.api.nvim_buf_get_name(listed_bufs[1]) == "" then
      MiniStarter.open()
    end
  end,
})

--- mini explorer / split
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    map_split(buf_id, "<C-s>", "belowright horizontal")
    map_split(buf_id, "<C-v>", "belowright vertical")
  end,
})

-- Have mini file explorer reveal the current file
-- [mini.files: "Reveal" current file in tree? · echasnovski/mini.nvim · Discussion #395](https://github.com/echasnovski/mini.nvim/discussions/395#discussioncomment-6418353)
_G.open_current = function() --- doesn't seem to be working
  local minifiles = require "mini.files"
  minifiles.open(vim.api.nvim_buf_get_name(0))
  minifiles.reveal_cwd()
end

vim.g.cmptoggle = false
local function toggleAutoComplete()
  vim.g.cmptoggle = not vim.g.cmptoggle

  require("cmp").setup {
    enabled = function()
      return vim.g.cmptoggle
    end,
  }

  local status = vim.g.cmptoggle and "enabled" or "disabled"
  vim.notify("AutoComplete " .. status, vim.log.levels.INFO)
end

-- Create a user command to manually trigger the toggle
vim.api.nvim_create_user_command("ToggleAutoComplete", toggleAutoComplete, {})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = toggleAutoComplete,
})
