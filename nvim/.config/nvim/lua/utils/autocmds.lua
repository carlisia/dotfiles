local helper = require "utils.functions"
local completion = require "utils.completion"

---- LSP
-- Attach my keymappins for all LSPs
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = require("utils.lspkeymaps").setkeys,
})

-- Mini explorer / split
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    helper.map_split(buf_id, "<C-s>", "belowright horizontal")
    helper.map_split(buf_id, "<C-v>", "belowright vertical")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if type(completion.toggle) == "function" then
      completion.toggle()
    end
  end,
})
