local present, blankline = pcall(require, "indent-blankline.nvim")

if not present then
	return
end

-- for sparkly dots in the indentation space
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

local options = {
	space_char_blankline = " ",
	show_current_context = true,
	show_current_context_start = true,
}

blankline.setup(options)
