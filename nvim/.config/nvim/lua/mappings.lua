local helper = require "utils.functions"
local completion = require "utils.completion"
local map = vim.keymap.set
-- local unmap = vim.keymap.del

map("n", "<leader>;", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
-- unmap("n", "\\")
-- map({ "n", "v" }, "\\d", "<Cmd>Neotree toggle<CR>", { desc = "Toggle 'nav tree'" })
map({ "n", "v" }, "\\a", completion.toggle, { desc = "Toggle 'autocomplete'" })

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
map({ "n", "t" }, "tt", helper.toggle_floating_term, { desc = "Toggle floating term" })
map({ "n", "t" }, "tj", helper.tggle_horizontal_term, { desc = "Toggle horizontal term" })
map({ "n", "t" }, "tl", helper.toggle_vertical_term, { desc = "Toggle vertical term" })

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

map("n", "\\e", helper.toggle_mini_explorer, { desc = "Toggle 'mini explorer'" })

map("n", "<leader>-s", "<Cmd>lua MiniSessions.select()<CR>", { desc = "Select a session" })
map("n", "<leader>-a", ":SaveSession<CR>", { desc = "Add a session" })
map("n", "<leader>-d", ":DeleteSession<CR>", { desc = "Delete a session" })

map({ "n", "v" }, "<leader>cd", helper.insert_done_comment, { noremap = true, silent = true, desc = "Insert -- DONE" })
map({ "n", "v" }, "<leader>cf", helper.insert_fix_comment, { noremap = true, silent = true, desc = "Insert -- FIX" })
map({ "n", "v" }, "<leader>ch", helper.insert_hack_comment, { noremap = true, silent = true, desc = "Insert -- HACK" })
map({ "n", "v" }, "<leader>cn", helper.insert_note_comment, { noremap = true, silent = true, desc = "Insert -- NOTE" })
map({ "n", "v" }, "<leader>ct", helper.insert_todo_comment, { noremap = true, silent = true, desc = "Insert -- TODO" })
