local M = {}

M.telescope = {
	n = {
		["<leader>f"] = {
			"<cmd> :Telescope find_files follow=true no_ignore=true hidden=true <CR>",
			"  find files",
		},
	},
}

M.shade = {
	n = {
		["<leader>sh"] = {
			function()
				require("shade").toggle()
			end,

			"   toggle shade.nvim",
		},

		["<leader>z"] = {
			function()
				require("nvterm.terminal").send("lazygit", "vertical")
			end,
			"nvterm lazygit",
		},
	},
}

M.searchbox = {
	n = {
		["<leader>sb"] = { "<cmd>lua require('searchbox').match_all({confirm = 'menu'})<CR>" },
		["<leader>r"] = { "<cmd>lua require('searchbox').replace({confirm = 'menu'})<CR>" },
	},

	x = {
		["<leader>sb"] = { "\"yy<cmd>lua require('custom.extensions').search()<CR>" },
		["<leader>r"] = { "\"yy<cmd>lua require('custom.extensions').search_and_replace()<CR>" },
	},
}

M.nvimtree = {
	n = {
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
		["<C-n>"] = { "<cmd> Telescope <CR>", "open telescope" },
	},
}

M.treesitter = {
	n = {
		["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "  find media" },
	},
}

return M
