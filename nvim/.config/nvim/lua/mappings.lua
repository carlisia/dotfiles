-- require "nvchad.mappings"
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
