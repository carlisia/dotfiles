local M = {}

-- M.treesitter = {
--   n = {
--     ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "  find media" },
--   },
-- }

-- M.nvimtree = {
--   n = {
--     ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
--     ["<C-n>"] = { "<cmd> Telescope <CR>", "open telescope" },
--   },
-- }

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

M.telescope = {
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

    ["<leader>ff"] = {
      "<cmd> :Telescope find_files follow=true no_ignore=true hidden=true <CR>",
      "  find files",
    },
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

    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
    ["<C-n>"] = { "<cmd> Telescope <CR>", "open telescope" },

    ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "  find media" },

  },
}

local map = vim.keymap.set

function M.lspconfig_keys(client, bufnr)
  local m = {
    declaration = "gD",
    definition = "gd",
    hover = "K",
    implementation = "gi",
    signature_help = "gk",
    add_workspace_folder = "<leader>wa",
    remove_workspace_folder = "<leader>wr",
    list_workspace_folders = "<leader>wl",
    type_definition = "<leader>D",
    rename = "<leader>re",
    code_action = "<leader>a",
    references = "gr",
    formatting = "<leader>fm",
    -- diagnostics
    workspace_diagnostics = "<leader>w",
    buffer_diagnostics = "<leader>d",
    goto_prev = "[d",
    goto_next = "]d",
  }

  local buf_k = function(mo, k, c)
    map(mo, k, c, { buffer = bufnr })
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_k("n", m.declaration, function()
    vim.lsp.buf.declaration()
  end)

  buf_k("n", m.definition, function()
    vim.lsp.buf.definition()
  end)

  buf_k("n", m.hover, function()
    vim.lsp.buf.hover()
  end)

  buf_k("n", m.implementation, function()
    vim.lsp.buf.implementation()
  end)

  buf_k("n", m.signature_help, function()
    vim.lsp.buf.signature_help()
  end)

  buf_k("n", m.type_definition, function()
    vim.lsp.buf.type_definition()
  end)

  buf_k("n", m.rename, function()
    vim.lsp.buf.rename()
  end)

  buf_k("n", m.code_action, function()
    vim.lsp.buf.code_action()
  end)

  buf_k("n", m.references, function()
    require("trouble").open("lsp_references")
  end)

  buf_k("n", m.goto_prev, function()
    vim.diagnostic.goto_prev()
  end)

  buf_k("n", m.goto_next, function()
    vim.diagnostic.goto_next()
  end)

  buf_k("n", m.workspace_diagnostics, function()
    if vim.diagnostic.get()[1] then
      require("trouble").open("workspace_diagnostics")
    else
      vim.notify("No workspace diagnostics found.")
    end
  end)

  buf_k("n", m.buffer_diagnostics, function()
    if vim.diagnostic.get()[1] then
      require("trouble").open("document_diagnostics")
    else
      vim.notify("No docunment diagnostics found.")
    end
  end)

  buf_k("n", m.add_workspace_folder, function()
    vim.lsp.buf.add_workspace_folder()
  end)

  buf_k("n", m.remove_workspace_folder, function()
    vim.lsp.buf.remove_workspace_folder()
  end)

  buf_k("n", m.list_workspace_folders, function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)

  if client.resolved_capabilities.document_formatting then
    buf_k("n", m.formatting, function()
      vim.lsp.buf.formatting_sync()
    end)
    buf_k("v", m.formatting, function()
      vim.lsp.buf.range_formatting()
    end)
  end
end

function M.searchbox()
  -- search
  map("n", "<leader>s", "<cmd>lua require('searchbox').match_all({confirm = 'menu'})<CR>")
  map("x", "<leader>s", "\"yy<cmd>lua require('custom.extensions').search()<CR>")

  -- search and replace
  map("n", "<leader>r", "<cmd>lua require('searchbox').replace({confirm = 'menu'})<CR>")
  map("x", "<leader>r", "\"yy<cmd>lua require('custom.extensions').search_and_replace()<CR>")
end

function M.general()
  -- select all text in a buffer
  map({ "n", "x" }, "<C-a>", "gg0vG$")
  -- save with c-s in all modes
  map({ "n", "x", "i" }, "<C-s>", "<cmd>:update<cr>")
  map("n", "<leader>fr", "<cmd>:Telescope resume<cr>")
  map("n", "<leader><leader>q", "<cmd>:qall<cr>")
  -- Reselect visual selection after indenting
  map("v", "<", "<gv")
  map("v", ">", ">gv")
  -- do not select the new line on y
  map("n", "Y", "y$")
  map("x", "Y", "<Esc>y$gv")
  -- Keep matches center screen when cycling with n|N
  map("n", "n", "nzzzv")
  map("n", "N", "Nzzzv")
  -- swap ; with :
  map({ "n", "o", "x" }, ";", ":")
  -- use H for start of line and L for end of line
  map({ "n", "o", "x" }, "H", "0")
  map({ "n", "o", "x" }, "L", "$")
end

return M
