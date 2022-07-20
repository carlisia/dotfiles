local opts = { noremap = true, silent = true }

-- Examples
-- :help map-arguments
-- :verbose map <TAB>
-- :map

-- vim.api.nvim_set_keymap('n', '<Leader><Space>', ':set hlsearch!<CR>', { noremap = true, silent = true })
-- -- Vim equivalent
-- -- :nnoremap <silent> <Leader><Space> :set hlsearch<CR>

-- vim.api.nvim_set_keymap('n', '<Leader>tegf',  [[<Cmd>lua require('telescope.builtin').git_files()<CR>]], { noremap = true, silent = true })
-- -- Vim equivalent
-- -- :nnoremap <silent> <Leader>tegf <Cmd>lua require('telescope.builtin').git_files()<CR>

-- vim.api.nvim_buf_set_keymap(0, '', 'cc', 'line(".") == 1 ? "cc" : "ggcc"', { noremap = true, expr = true })
-- -- Vim equivalent
-- -- :noremap <buffer> <expr> cc line('.') == 1 ? 'cc' : 'ggcc'

-- To modify a single Lunarvim keymapping
--   -- X closes a buffer
--   lvim.keys.normal_mode["<S-x>"] = ":BufferClose<CR>"

-- To remove keymappings set by Lunarvim
--   -- use the default vim behavior for H and L
--   lvim.keys.normal_mode["<S-l>"] = false
--   lvim.keys.normal_mode["<S-h>"] = false
--   -- vim.opt.scrolloff = 0 -- Required so L moves to the last line

