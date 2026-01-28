local toggles = require "utils.toggles"

local map = vim.keymap.set
local unmap = vim.keymap.del

-- Normal mode move cursor to end of pasted text
map("n", "p", "p`]", { noremap = true })
map("n", "P", "P`]", { noremap = true })

-- Visual mode move cursor to end of pasted text
map("v", "p", "p`]", { noremap = true })
map("v", "P", "P`]", { noremap = true })

map("n", "<leader>;", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map({ "n", "v" }, "\\a", toggles.autocomplete, { desc = "Toggle 'autocomplete'" })
map({ "n", "v" }, "\\u", "<Cmd>DBUIToggle<CR>", { desc = "Toggle 'DB ui'" })
map({ "n", "v" }, "\\q", toggles.loclist, { desc = "Toggle 'loclist'" })
map({ "n", "v" }, "\\Q", toggles.quickfix, { desc = "Toggle 'quickfix'" })

unmap({ "n", "v", "o" }, "gc")
unmap("n", "gcc")

map({ "n", "v" }, "<Tab>", "za")
map({ "n", "v" }, "U", "<C-r>")

---- nvchad theme switcher
map("n", "<leader>v", function()
  require("nvchad.themes").open()
end, { desc = "Theme switcher" })

---- nvchad tabufline ------ buffers --------
map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close x" })

map("n", "<M-Tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next", noremap = true })

map("n", "<leader>bh", function()
  local current_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  -- Try to move left; if fails, create the split
  vim.cmd "wincmd h"
  local new_win = vim.api.nvim_get_current_win()

  if new_win == current_win then
    vim.cmd "leftabove vsplit"
  end

  vim.cmd "wincmd h"
  vim.cmd("buffer " .. buf)
end, { desc = "Send to <--" })

map("n", "<leader>bl", function()
  local current_win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  -- Try to move right; if fails, create the split
  vim.cmd "wincmd l"
  local new_win = vim.api.nvim_get_current_win()

  if new_win == current_win then
    -- No right split existed, so create one
    vim.cmd "vsplit"
  end

  -- Now go to the right (new or existing) and load buffer
  vim.cmd "wincmd l"
  vim.cmd("buffer " .. buf)
end, { desc = "Send to -->" })

map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<leader>bt", ":b#<CR>", { desc = "Toggle buffers" })
map("n", "<leader>fs", "<cmd>normal! ggVG<CR>", { desc = "Select all" })
map("n", "<leader>fy", ":%y+<CR>", { desc = "Yank all" })
map("n", "<leader>fp", 'gg"_dG"+P', { desc = "Replace all" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

map("n", "<leader>f%", function()
  local pattern
  vim.ui.input({ prompt = "Substitute pattern: " }, function(input1)
    if not input1 or input1 == "" then
      return
    end
    pattern = input1

    local match_id = vim.fn.matchadd("IncSearch", pattern)

    vim.ui.input({ prompt = "Replace with: " }, function(input2)
      if not input2 or input2 == "" then
        vim.notify("Substitution cancelled", vim.log.levels.INFO)
        vim.fn.matchdelete(match_id)
        return
      end

      vim.cmd(string.format("%%s/%s/%s/g", pattern, input2))
      vim.defer_fn(function()
        vim.fn.matchdelete(match_id)
      end, 300)
    end)
  end)
end, { desc = "Substitute in file" })

vim.keymap.set("n", "<leader>fd", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to trash", vim.log.levels.INFO)
    return
  end

  local project_relative_path = vim.fn.fnamemodify(file, ":~:.")
  vim.ui.select({ "No", "Yes" }, {
    prompt = "Moving to Trash:\n" .. project_relative_path .. "\n\n- Are you sure?",
  }, function(choice)
    if choice ~= "Yes" then
      vim.notify("Move to trash cancelled", vim.log.levels.INFO)
      return
    end

    vim.fn.jobstart({ "trash", file }, {
      on_exit = function()
        vim.notify("Moved to trash: " .. project_relative_path, vim.log.levels.INFO)
        vim.cmd "OutlineClose"
        vim.cmd "bd!"
      end,
    })
  end)
end, { desc = "Delete file" })

---- Terminal
local term = require "nvchad.term"
map({ "n", "t" }, "<M-f>", function() -- float
  term.toggle { pos = "float", id = "floatTerm" }
end, { desc = "Toggle floating term" })
map({ "n", "t" }, "<M-b>", function() -- bottom
  term.toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle horizontal term" })
map({ "n", "t" }, "<M-s>", function() -- side
  term.toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Toggle vertical term" })

---- mini
map("n", "\\e", toggles.mini_explorer, { desc = "Toggle 'mini explorer'" })

map("n", "\\m", toggles.mini_map, { desc = "Toggle 'mini map'" })
map("n", "\\M", toggles.mini_map_focus, { desc = "Focus 'mini map'" })

map("n", "<leader>-a", "<Cmd>lua MiniSessions.write(vim.fn.input('Session Name > '))<CR>", { desc = "Add a session" })
map("n", "<leader>-d", "<Cmd>lua MiniSessions.select('delete')<CR>", { desc = "Delete a session" })
map("n", "<leader>-s", "<Cmd>lua MiniSessions.select()<CR>", { desc = "Select a session" })
map("n", "<leader>-u", "<Cmd>lua MiniSessions.select('write')<CR>", { desc = "Update a session" })
map("n", "<leader>-p", "<Cmd>lua MiniSessions.read(MiniSessions.get_latest())<CR>", { desc = "Pop the latest session" })
