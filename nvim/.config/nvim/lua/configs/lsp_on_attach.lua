---- LSP
-- Attach bustom keymappins for LSPs
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = require("utils.lspkeymaps").setkeys,
})
