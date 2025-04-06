local M = {}

M.govim = {
  go = "go", -- go command, can be go[default] or e.g. go1.18beta1
  test_runner = "gotestsum",
  lsp_cfg = false,
  lsp_keymaps = false,
  dap_debug = true,
  dap_debug_gui = true,
  dap_debug_keymap = true,
  comment_placeholder = "   ",
  lsp_inlay_hints = { enable = true },
  comment = {
    highlight = true,
  },
  run_in_floaterm = true,
  luasnip = true,
  diagnostic = {
    hdlr = true,
  },
}

return M
