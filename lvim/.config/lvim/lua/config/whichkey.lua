local wk = lvim.builtin.which_key

-- Use which-key to add extra bindings with the leader-key prefix
wk.mappings["m"] = { "<cmd>Telescope marks<CR>", "  Marks" }
wk.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
wk.mappings["r"] = { "<cmd>RnvimrToggle<CR>", "  Ranger" }
wk.mappings["u"] = { "<cmd>Telescope oldfiles<CR>", "  Recently Used Files" }
wk.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}
