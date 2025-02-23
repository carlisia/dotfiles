require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del

map("n", "<leader>;", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")
unmap("n", "\\")
map({ "n", "v" }, "|", "<Cmd>Neotree toggle<CR>")

unmap("n", "<leader>n")
unmap("n", "<leader>rn")
unmap({ "n", "v" }, "<leader>/")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- ╭─────────────────────────────────────────────────────────╮
-- │ which-key                                               │
-- ╰─────────────────────────────────────────────────────────╯
local groups = {
  { "<leader>b", group = "🐐 [b]uffer" },
  { "<leader>f", group = "🧿 [f]ind" },
  { "<leader>g", group = "🚀 [g]it" },
  { "<leader>h", group = "🌈 [h]istory" },
  { "<leader>k", group = "🔑 [k]eys" },
  { "<leader>l", group = "📚 [l]sp" },
  { "<leader>s", group = "🍿 [s]nacks" },
  { "<leader>t", group = "🔭 [t]telescope" },
}
require("which-key").add(groups)

-- ╭─────────────────────────────────────────────────────────╮
-- │ Keys                                                    │
-- ╰─────────────────────────────────────────────────────────╯
unmap("n", "<leader>wK")
unmap("n", "<leader>wk")
unmap("n", "<leader>ch")
map("n", "<leader>kW", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
map("n", "<leader>kw", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })
map("n", "<leader>kc", "<cmd>NvCheatsheet<CR>", { desc = "nvcheatsheet" })
-- ╭─────────────────────────────────────────────────────────╮
-- │ Files                                                   │
-- ╰─────────────────────────────────────────────────────────╯
require("mini.files").setup()
local minifiles_toggle = function(...)
  if not MiniFiles.close() then
    MiniFiles.open(...)
  end
end
map("n", "<leader>e", minifiles_toggle, { desc = "mini explorer" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Buffers                                                 │
-- ╰─────────────────────────────────────────────────────────╯
map("n", "<leader>bb", ":b#<CR>", { desc = "Toggle buffers" })
-- tabufline
unmap("n", "<leader>b")
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "buffer new" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Terminal                                                │
-- ╰─────────────────────────────────────────────────────────╯
unmap("n", "<leader>h")
unmap("n", "<leader>v")
unmap("t", "<C-x>")
-- Floater
map({ "n", "t" }, "<C-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- Horizontal
-- toggle
map({ "n", "t" }, "<C-j>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

-- Vertical
-- toggleable
map({ "n", "t" }, "<C-l>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Telescope                                               │
-- ╰─────────────────────────────────────────────────────────╯
unmap("n", "<leader>fw")
unmap("n", "<leader>fb")
unmap("n", "<leader>fh")
unmap("n", "<leader>ma")
unmap("n", "<leader>fo")
unmap("n", "<leader>fz")
unmap("n", "<leader>cm")
unmap("n", "<leader>gt")
unmap("n", "<leader>pt")
unmap("n", "<leader>fa")
unmap("n", "<leader>ff")
map("n", "<leader>t/", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>tb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>th", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>tm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>to", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>tf", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>tgc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>tgs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader=tt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ LSP                                                     │
-- ╰─────────────────────────────────────────────────────────╯
-- global lsp mappings
unmap("n", "<leader>ds")
map("n", "<leader>lp", vim.diagnostic.setloclist, { desc = "problem/diagnostic loclist" })

unmap("n", "<leader>fm") -- format file
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format file" })
