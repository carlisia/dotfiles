local M = {}

M.govim = {
  goimports = "gopls", -- if set to 'gopls' will use golsp format
  gofmt = "gopls", -- if set to gopls will use golsp format
  tag_transform = false,
  test_dir = "",
  comment_placeholder = "   ",
  lsp_cfg = true, -- false: use your own lspconfig
  lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = false, -- use on_attach from go.nvim
  dap_debug = true,
}

return M
