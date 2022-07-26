local M = {}

M.treesitter = {
  n = {
    ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "  find media" },
  },
}

M.nvimtree = {
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
    ["<C-n>"] = { "<cmd> Telescope <CR>", "open telescope" },
  },
}

-- [[ tips for lsp_lines
-- https://git.sr.ht/~whynothugo/lsp_lines.nvim

-- This plugin's functionality can be disabled with:
-- vim.diagnostic.config({ virtual_lines = false })
-- And it can be re-enabled via:
-- vim.diagnostic.config({ virtual_lines = true })
--
-- A helper is also provided to toggle, which is convenient for mappings:
-- -- vim.keymap.set(
--   "",
--   "<Leader>l",
--   require("lsp_lines").toggle,
--   { desc = "Toggle lsp_lines" }
-- )
-- ]]

M.Dashboard = {
  n = {
    ["<leader>m"] = { "<cmd>Telescope marks<CR>", "  Marks" },
    -- ["<leader>n"] = { "<cmd>Notifications<CR>", "History  " },
    -- ["<leader>n"] = { "<cmd>Notifications<CR>", "History  " },
    -- ["P"] = { "<cmd>Telescope projects<CR>", "Projects" },
    -- 	["r"] = { "<cmd>RnvimrToggle<CR>", "  Ranger" },
    -- ["u<leader>u"] = { "<cmd>Telescope oldfiles<CR>", "  Recently Used Files" },
    -- ["t"] = {
    -- 	name = "+Trouble",
    -- 	r = { "<cmd>Trouble lsp_references<cr>", "References" },
    -- 	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    -- 	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
    -- 	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    -- 	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    -- 	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
    -- },
  },
}

M.telescope = {
  n = {
    ["<leader>ff"] = {
      "<cmd> :Telescope find_files follow=true no_ignore=true hidden=true <CR>",
      "  find files",
    },
  },
}

M.shade = {
  n = {
    ["<leader>s"] = {
      function()
        require("shade").toggle()
      end,

      "   toggle shade.nvim",
    },

    ["<leader>lz"] = {
      function()
        require("nvterm.terminal").send("lazygit", "vertical")
      end,
      "nvterm lazygit",
    },
  },
}

-- local map = vim.keymap.set
-- function M.misc()
--   -- select all text in a buffer
--   map({ "n", "x" }, "<C-a>", "gg0vG$")
--   -- save with c-s in all modes
--   map({ "n", "x", "i" }, "<C-s>", "<cmd>:update<cr>")
--   map("n", "<leader>fr", "<cmd>:Telescope resume<cr>")
--   map("n", "<leader><leader>q", "<cmd>:qall<cr>")
--   -- Reselect visual selection after indenting
--   map("v", "<", "<gv")
--   map("v", ">", ">gv")
--   -- do not select the new line on y
--   map("n", "Y", "y$")
--   map("x", "Y", "<Esc>y$gv")
--   -- Keep matches center screen when cycling with n|N
--   map("n", "n", "nzzzv")
--   map("n", "N", "Nzzzv")
--   -- swap ; with :
--   map({ "n", "o", "x" }, ";", ":")
--   -- use H for start of line and L for end of line
--   map({ "n", "o", "x" }, "H", "0")
--   map({ "n", "o", "x" }, "L", "$")
-- end

return M
