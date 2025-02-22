require "nvchad.mappings"
-- [NvChad/lua/nvchad/mappings.lua at v2.5 · NvChad/NvChad](https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua)

local map = vim.keymap.set

map("n", "<leader>;", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({ "n" }, "\\", "<Cmd>Neotree toggle<CR>")

-- ╭─────────────────────────────────────────────────────────╮
-- │ Keys                                                    │
-- ╰─────────────────────────────────────────────────────────╯
vim.keymap.del("n", "<leader>wK")
vim.keymap.del("n", "<leader>wk")
vim.keymap.del("n", "<leader>ch")
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
map("n", "<leader>e", minifiles_toggle, { desc = "Mini Files Explorer" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Buffers                                                 │
-- ╰─────────────────────────────────────────────────────────╯

map("n", "<leader>bb", ":b#<CR>", { desc = "Toggle buffers" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Terminal                                                │
-- ╰─────────────────────────────────────────────────────────╯
vim.keymap.del("n", "<leader>h")
vim.keymap.del("n", "<leader>v")
vim.keymap.del("t", "<C-x>")
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
