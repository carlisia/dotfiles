local helper = require "utils.functions"
local completion = require "utils.completion"

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
map({ "n", "v" }, "\\a", completion.toggle, { desc = "Toggle 'autocomplete'" })
map({ "n", "v" }, "\\u", "<Cmd>DBUIToggle<CR>", { desc = "Toggle 'DB ui'" })
map({ "n", "v" }, "\\q", helper.toggle_quickfix, { desc = "Toggle 'quickfix'" })

unmap({ "n", "v", "o" }, "gc")
unmap("n", "gcc")

map({ "n", "v" }, "<Tab>", "za")
map({ "n", "v" }, "U", "<C-r>")

---- nvchad theme switcher
map("n", "<leader>v", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

---- nvchad tabufline ------ buffers --------
map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

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
end, { desc = "Send to <-- " })

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
end, { desc = "Send to -->)" })

map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<leader>bt", ":b#<CR>", { desc = "Toggle buffers" })

---- Terminal
map({ "n", "t" }, "tt", helper.toggle_floating_term, { desc = "Toggle floating term" })
map({ "n", "t" }, "tj", helper.tggle_horizontal_term, { desc = "Toggle horizontal term" })
map({ "n", "t" }, "tl", helper.toggle_vertical_term, { desc = "Toggle vertical term" })

---- mini
map("n", "\\e", helper.toggle_mini_explorer, { desc = "Toggle 'mini explorer'" })

map("n", "<leader>-a", "<Cmd>lua MiniSessions.write(vim.fn.input('Session Name > '))<CR>", { desc = "Add a session" })
map("n", "<leader>-d", "<Cmd>lua MiniSessions.select('delete')<CR>", { desc = "Delete a session" })
map("n", "<leader>-s", "<Cmd>lua MiniSessions.select()<CR>", { desc = "Select a session" })
map("n", "<leader>-u", "<Cmd>lua MiniSessions.select('write')<CR>", { desc = "Update a session" })
map("n", "<leader>-p", "<Cmd>lua MiniSessions.read(MiniSessions.get_latest())<CR>", { desc = "Pop the latest session" })

vim.keymap.set("n", "<leader>fa", ":%y+<CR>", { desc = "Select all" })
vim.keymap.set("n", "<leader>fp", 'gg"_dG"+P', { desc = "Replace all" })
