local M = {}

M.govim = {
  go = "go", -- go command, can be go[default] or e.g. go1.18beta1
  test_runner = "richgo",
  lsp_cfg = true,
  lsp_keymaps = false,
  dap_debug_keymap = true,
  comment_placeholder = "   ",
}

return M
