require "nvchad.options"

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "lua Snacks.dashboard()"
    end
  end,
})

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

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    map_split(buf_id, "<C-s>", "belowright horizontal")
    map_split(buf_id, "<C-v>", "belowright vertical")
  end,
})

-- Have mini file explorer reveal the current file
_G.open_current = function()
  local minifiles = require "mini.files"
  minifiles.open(vim.api.nvim_buf_get_name(0))
  minifiles.reveal_cwd()
end
--- end
