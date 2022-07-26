vim.opt.rtp:append(vim.fn.stdpath("config") .. "/lua/custom/runtime")
vim.opt.pumheight = 30

vim.opt.shell = "/usr/local/bin/bash"
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars:append("space:⋅")

vim.defer_fn(function()
	-- Create directory if missing: https://github.com/jghauser/mkdir.nvim
	vim.cmd([[autocmd BufWritePre * lua require('custom.utils').create_dirs()]])

	-- only enable treesitter folding if enabled
	vim.cmd([[autocmd BufWinEnter * lua require('custom.utils').enable_folding()]])

	vim.cmd("hi! Folded guifg=#fff")

	vim.cmd("silent! command Sudowrite lua require('custom.utils').sudo_write()")
end, 0)

local api = vim.api
local autocmd = api.nvim_create_autocmd

-- Dynamic terminal padding with/without nvim (for siduck's st only)
-- replace stuff from file
local function sed(from, to, fname)
	vim.cmd(string.format("silent !sed -i 's/%s/%s/g' %s", from, to, fname))
end

-- reloads xresources for current focused window only
local function liveReload_xresources()
	vim.cmd(
		string.format(
			"silent !xrdb merge ~/.Xresources && kill -USR1 $(xprop -id $(xdotool getwindowfocus) | grep '_NET_WM_PID' | grep -oE '[[:digit:]]*$')"
		)
	)
end

autocmd({ "BufNewFile", "BufRead" }, {
	callback = function(ctx)
		-- remove terminal padding
		-- exclude when nvim has norg ft & more than 2 buffers
		if vim.bo.ft == "norg" or #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
			sed("st.borderpx: 20", "st.borderpx: 0", "~/.Xresources")
			liveReload_xresources()

			-- revert xresources change but dont reload it
			sed("st.borderpx: 0", "st.borderpx: 20", "~/.Xresources")
			vim.cmd(string.format("silent !xrdb merge ~/.Xresources"))
			api.nvim_del_autocmd(ctx.id)
		end
	end,
})

-- add terminal padding
autocmd("VimLeavePre", {
	callback = function()
		sed("st.borderpx: 0", "st.borderpx: 20", "~/.Xresources")
		liveReload_xresources()
	end,
})
