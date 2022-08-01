local opt = vim.opt

opt.rtp:append(vim.fn.stdpath("config") .. "/lua/custom/runtime")
opt.pumheight = 30

opt.shell = "/usr/local/bin/bash"
opt.termguicolors = true
opt.list = true
opt.listchars:append("space:⋅")

-- this is for trld so there's no duplicate messages
vim.diagnostic.config({ virtual_text = false })

vim.defer_fn(function()
  -- Create directory if missing: https://github.com/jghauser/mkdir.nvim
  vim.cmd([[autocmd BufWritePre * lua require('custom.extensions').create_dirs()]])

  -- only enable treesitter folding if enabled
  vim.cmd([[autocmd BufWinEnter * lua require('custom.extensions').enable_folding()]])

  vim.cmd("hi! Folded guifg=#fff")

  vim.cmd("silent! command Sudowrite lua require('custom.extensions').sudo_write()")
end, 0)

local new_cmd = vim.api.nvim_create_user_command

new_cmd("EnableShade", function()
  require("shade").setup()
end, {})

new_cmd("EnableAutosave", function()
  require("autosave").setup()
end, {})

new_cmd("EnableTelescope", function()
  require("telescope").setup()
end, {})
