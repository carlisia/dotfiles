local helper = require "utils.functions"
local completion = require "utils.completion"

-- Mini starter
-- At startup, auto open mini.starter if no files are opened
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local has_mini, ministarter = pcall(require, "mini.starter")
    if has_mini and vim.fn.argc() == 0 then
      ministarter.open()
    end
  end,
})

-- Mini starter: auto open when the last buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local ministarter = require "mini.starter"
    local listed_bufs = vim.t.bufs or {}
    if #listed_bufs == 1 and vim.api.nvim_buf_get_name(listed_bufs[1]) == "" then
      ministarter.open()
    end
  end,
})

--- Mini explorer / split
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    helper.map_split(buf_id, "<C-s>", "belowright horizontal")
    helper.map_split(buf_id, "<C-v>", "belowright vertical")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = completion.toggle,
})

-- Attach my keymappins for all LSPs
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = require("utils.lspkeymaps").setkeys,
})
