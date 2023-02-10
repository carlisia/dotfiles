---@type MappingsConfig

local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.disabled = {
  n = {
    ["<C-n>"] = "",
    ["<leader>e"] = "",
    -- disable telescope live grep and use nvchad's
    ["<C-s>"] = "",
    ["<C-c>"] = "",
    ["<leader>fw"] = "",
  },
}

M.telescope = {
  n = {
    ["<leader>ff"] = {
      "<cmd> :Telescope find_files follow=true hidden=true <CR>",
      "find files",
    },
    ["<leader>ft"] = { "<cmd> Telescope live_grep <CR>", "  find text" },
  },
}

return M
