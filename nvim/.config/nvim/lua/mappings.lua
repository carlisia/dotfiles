require "nvchad.mappings"
-- [NvChad/lua/nvchad/mappings.lua at v2.5 · NvChad/NvChad](https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua)

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({ "n" }, "\\", "<Cmd>Neotree toggle<CR>")

require("mini.files").setup()
local minifiles_toggle = function(...)
  if not MiniFiles.close() then
    MiniFiles.open(...)
  end
end
map("n", "<leader>e", minifiles_toggle, { desc = "Mini Files Explorer" })

map("n", "<leader>bb", ":b#<CR>", { desc = "Toggle buffers" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- ╭─────────────────────────────────────────────────────────╮
-- │ Terminal                                                │
-- ╰─────────────────────────────────────────────────────────╯
-- Floater
map({ "n", "t" }, "<C-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- Horizontal
-- open
map("n", "<leader>j", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })
-- toggle
map({ "n", "t" }, "<C-j>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

-- Vertical
-- open
map("n", "<leader>l", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })
-- toggleable
map({ "n", "t" }, "<C-l>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })
