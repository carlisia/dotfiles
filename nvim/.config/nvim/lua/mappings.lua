vim.cmd [[
hi! MiniHipatternsCustDone guifg=#000000 guibg=#00CC00 gui=bold
hi! MiniHipatternsCustNote guifg=#FF4000 guibg=#FFFF00 gui=bold
]]

local map = vim.keymap.set
-- local unmap = vim.keymap.del

map("n", "<leader>;", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
-- unmap("n", "\\")
-- map({ "n", "v" }, "\\d", "<Cmd>Neotree toggle<CR>", { desc = "Toggle 'nav tree'" })
map({ "n", "v" }, "\\a", "<Cmd>ToggleAutoComplete<CR>", { desc = "Toggle 'autocomplete'" })

-- unmap("n", "<leader>e")
-- unmap("n", "<leader>n")
-- unmap("n", "<leader>rnY)
-- unmap({ "n", "v" }, "<leader>/")

-- unmap({ "n", "v", "o" }, "gc")
-- unmap("n", "gcc")

map({ "n", "v" }, "<Tab>", "za")

map({ "n", "v" }, "U", "<C-r>")

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

map("n", "<M-Tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next", noremap = true })
--

-- ╭─────────────────────────────────────────────────────────╮
-- │ which-key                                       pen Snacks Explorer"        │
-- ╰─────────────────────────────────────────────────────────╯
-- local groups = {
--   { "<leader>b", group = "🐐 [b]uffer" },
--   { "<leader>f", group = "🧿 [f]ind" },
--   { "<leader>g", group = "🚀 [g]it" },
--   { "<leader>h", group = "🌈 [h]istory" },
--   { "<leader>k", group = "🔑 [k]eys" },
--   { "<leader>l", group = "📚 [l]sp" },
--   { "<leader>s", group = "🍿 [s ks]nacks" },
--   { "<leader>t", group = "🔭 [t]telescope" },
--   { "<leader>-", group = "📟 [-] mini sessions" },
--
-- require("which-key").add(groups)

-- ╭─────────────────────────────────────────────────────────╮
-- │ Keys                                                    │
-- ╰─────────────────────────────────────────────────────────╯
-- unmap("n", "<leader>wK")
-- unmap("n", "<leader>wk")
-- unmap("n", "<leader>ch")
-- map("n", "<leader>kW", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
-- map("n", "<leader>kw", function()
--   vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
-- end, { desc = "whichkey query lookup" })
-- map("n", "<leader>kc", "<cmd>NvCheatsheet<CR>", { desc = "nvcheatsheet" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Buffers                                                 │
-- ╰─────────────────────────────────────────────────────────╯
map("n", "<leader>bb", ":b#<CR>", { desc = "Toggle buffers" })
-- tabufline
-- unmap("n", "<leader>b")
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Terminal                                                │
-- ╰─────────────────────────────────────────────────────────╯
-- unmap("n", "<leader>h")
-- unmap("n", "<leader>v")
-- unmap("t", "<C-x>")
-- unmap({ "n", "t" }, "<A-v>")
-- unmap({ "n", "t" }, "<A-h>")
-- unmap({ "n", "t" }, "<A-i>")
-- Floater
map({ "n", "t" }, "tt", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- Horizontal
-- toggle
map({ "n", "t" }, "tj", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

-- Vertical
-- toggleable
map({ "n", "t" }, "tl", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Telescope                                               │
-- ╰─────────────────────────────────────────────────────────╯
-- unmap("n", "<leader>fw")
-- unmap("n", "<leader>fb")
-- unmap("n", "<leader>fh")
-- unmap("n", "<leader>ma")
-- unmap("n", "<leader>fo")
-- unmap("n", "<leader>fz")
-- unmap("n", "<leader>cm")
-- unmap("n", "<leader>gt")
-- unmap("n", "<leader>pt")
-- unmap("n", "<leader>fa")
-- unmap("n", "<leader>ff")
-- map("n", "<leader>t/", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
-- map("n", "<leader>tb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
-- map("n", "<leader>tm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
-- map("n", "<leader>to", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
-- map("n", "<leader>tf", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
-- map("n", "<leader>tgc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
-- map("n", "<leader>tgs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
-- map("n", "<leader>=tt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ LSP                                                     │
-- ╰─────────────────────────────────────────────────────────╯
-- global lsp mappings
-- unmap("n", "<leader>ds")
map("n", "<leader>lp", vim.diagnostic.setloclist, { desc = "problem/diagnostic loclist" })

-- unmap("n", "<leader>fm") -- format file
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format file" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Mini                                                    │
-- ╰─────────────────────────────────────────────────────────╯
-- explorer
local minifiles_toggle = function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end
vim.keymap.set("n", "\\e", minifiles_toggle, { desc = "Toggle 'mini explorer'" })
--- end

-- sessions
local command = vim.api.nvim_create_user_command
-- Create a user command that can be executed with :SaveSession
command("SaveSession", function()
  MiniSessions.write(nil, { force = false })
end, {})
-- Create a user command that can be executed with :DeleteSession
command("DeleteSession", function()
  MiniSessions.delete(nil, { force = false })
end, {})

map("n", "<leader>-s", "<Cmd>lua MiniSessions.select()<CR>", { desc = "Select a session" })
map("n", "<leader>-a", ":SaveSession<CR>", { desc = "Add a session" })
map("n", "<leader>-d", ":DeleteSession<CR>", { desc = "Delete a session" })

--- Add custom text for highlighting
function InsertDoneComment()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " DONE: " })
end

function InsertFixComment()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " FIX: " })
end

function InsertHackomment()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " HACK: " })
end

function InsertNoteComment()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " NOTE: " })
end

function InsertTodoComment()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1
  local col = cursor_pos[2]
  vim.api.nvim_buf_set_text(0, line, col, line, col, { " TODO: " })
end

map({ "n", "v" }, "<leader>cd", InsertDoneComment, { noremap = true, silent = true, desc = "Insert -- DONE" })
map({ "n", "v" }, "<leader>cf", InsertFixComment, { noremap = true, silent = true, desc = "Insert -- FIX" })
map({ "n", "v" }, "<leader>ch", InsertHackomment, { noremap = true, silent = true, desc = "Insert -- HACK" })
map({ "n", "v" }, "<leader>cn", InsertNoteComment, { noremap = true, silent = true, desc = "Insert -- NOTE" })
map({ "n", "v" }, "<leader>ct", InsertTodoComment, { noremap = true, silent = true, desc = "Insert -- TODO" })
