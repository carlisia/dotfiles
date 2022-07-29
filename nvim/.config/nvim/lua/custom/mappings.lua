-- kes
-- :Notifications

local M = {}

-- local Terminal = require('toggleterm.terminal').Terminal
-- local toggle_float = function()
--   local float = Terminal:new({direction = "float"})
--   return float:toggle()
-- end
-- local toggle_lazygit = function()
--   local lazygit = Terminal:new({cmd = 'lazygit', direction = "float"})
--   return lazygit:toggle()
-- end /

M.keys = {
	[";"] = { "<cmd>Alpha<CR>", "Dashboard" },
	q = { ":q<cr>", "Quit" },
	Q = { ":wq<cr>", "Save & Quit" },
	w = { ":w<cr>", "Save" },
	x = { ":bdelete<cr>", "Close" },
	E = { ":e ~/.config/nvim/init.lua<cr>", "Edit config" },
	f = { ":Telescope find_files<cr>", "Telescope Find Files" },
	r = { ":Telescope live_grep<cr>", "Telescope Live Grep" },
	t = {
		t = { ":ToggleTerm<cr>", "Split Below" },
		-- f = {toggle_float, "Floating Terminal"},
		-- l = {toggle_lazygit, "LazyGit"}
	},
	n = { "<cmd>Telescope notify<cr>", "View Notifications" },
	-- r = { "<cmd>LvimReload<cr>", "Reload LunarVim's configuration" },

	g = {
		name = "Git",
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		C = {
			"<cmd>Telescope git_bcommits<cr>",
			"Checkout commit(for current file)",
		},
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Git Diff",
		},
	},

	l = {
		name = "LSP",
		i = { ":LspInfo<cr>", "Connected Language Servers" },
		k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
		K = { "<cmd>Lspsaga hover_doc<cr>", "Hover Commands" },
		w = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Workspace Folder" },
		W = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Workspace Folder" },
		l = {
			"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
			"List Workspace Folders",
		},
		t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
		d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go To Definition" },
		D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go To Declaration" },
		r = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
		R = { "<cmd>Lspsaga rename<cr>", "Rename" },
		a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
		e = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show Line Diagnostics" },
		n = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Go To Next Diagnostic" },
		N = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Go To Previous Diagnostic" },
	},

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		p = {
			"<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
			"Colorscheme with Preview",
		},
	},

	-- focus
	e = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },

	i = {
		["jk"] = { "<ESC>", "escape insert mode", noremap = true },
		["kj"] = { "<ESC>", "escape insert mode", noremap = true },
	},
}

local map = vim.keymap.set
function M.lspconfig_keys(client, bufnr)
	local m = {
		declaration = "gD",
		definition = "gd",
		hover = "K",
		implementation = "gi",
		signature_help = "gk",
		add_workspace_folder = "<leader>wa",
		remove_workspace_folder = "<leader>wr",
		list_workspace_folders = "<leader>wl",
		type_definition = "<leader>D",
		rename = "<leader>re",
		code_action = "<leader>a",
		references = "gr",
		formatting = "<leader>fm",
		-- diagnostics
		workspace_diagnostics = "<leader>w",
		buffer_diagnostics = "<leader>d",
		-- goto_prev = "[d",
		--[[ 		-- goto_next = "]d", ]]
	}

	local buf_k = function(mo, k, c)
		map(mo, k, c, { buffer = bufnr })
	end

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_k("n", m.declaration, function()
		vim.lsp.buf.declaration()
	end)

	buf_k("n", m.definition, function()
		vim.lsp.buf.definition()
	end)

	buf_k("n", m.hover, function()
		vim.lsp.buf.hover()
	end)
	--
	buf_k("n", m.implementation, function()
		vim.lsp.buf.implementation()
	end)

	buf_k("n", m.signature_help, function()
		vim.lsp.buf.signature_help()
	end)

	buf_k("n", m.type_definition, function()
		vim.lsp.buf.type_definition()
	end)

	buf_k("n", m.rename, function()
		vim.lsp.buf.rename()
	end)

	buf_k("n", m.code_action, function()
		vim.lsp.buf.code_action()
	end)

	buf_k("n", m.references, function()
		require("trouble").open("lsp_references")
	end)

	buf_k("n", m.goto_prev, function()
		vim.diagnostic.goto_prev()
	end)

	buf_k("n", m.goto_next, function()
		vim.diagnostic.goto_next()
	end)

	buf_k("n", m.workspace_diagnostics, function()
		if vim.diagnostic.get()[1] then
			require("trouble").open("workspace_diagnostics")
		else
			vim.notify("No workspace diagnostics found.")
		end
	end)
	--
	buf_k("n", m.buffer_diagnostics, function()
		if vim.diagnostic.get()[1] then
			require("trouble").open("document_diagnostics")
		else
			vim.notify("No docunment diagnostics found.")
		end
	end)
	--
	buf_k("n", m.add_workspace_folder, function()
		vim.lsp.buf.add_workspace_folder()
	end)

	buf_k("n", m.remove_workspace_folder, function()
		vim.lsp.buf.remove_workspace_folder()
	end)

	buf_k("n", m.list_workspace_folders, function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end)

	if client.resolved_capabilities.document_formatting then
		buf_k("n", m.formatting, function()
			vim.lsp.buf.formatting_sync()
		end)
		buf_k("v", m.formatting, function()
			vim.lsp.buf.range_formatting()
		end)
	end
end
--
-- M.lspconfig = {
-- 	-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
-- 	n = {
-- 		["gD"] = {
-- 			function()
-- 				vim.lsp.buf.declaration()
-- 			end,
-- 			"   lsp declaration",
-- 		},
--
-- 		["gd"] = {
-- 			function()
-- 				vim.lsp.buf.definition()
-- 			end,
-- 			"   lsp definition",
-- 		},
--
-- 		["K"] = {
-- 			function()
-- 				vim.lsp.buf.hover()
-- 			end,
-- 			"   lsp hover",
-- 		},
--
-- 		["gi"] = {
-- 			function()
-- 				vim.lsp.buf.implementation()
-- 			end,
-- 			"   lsp implementation",
-- 		},
--
-- 		["<leader>ls"] = {
-- 			function()
-- 				vim.lsp.buf.signature_help()
-- 			end,
-- 			"   lsp signature_help",
-- 		},
--
-- 		["<leader>D"] = {
-- 			function()
-- 				vim.lsp.buf.type_definition()
-- 			end,
-- 			"   lsp definition type",
-- 		},
--
-- 		["<leader>ra"] = {
-- 			function()
-- 				require("nvchad_ui.renamer").open()
-- 			end,
-- 			"   lsp rename",
-- 		},
--
-- 		["<leader>ca"] = {
-- 			function()
-- 				vim.lsp.buf.code_action()
-- 			end,
-- 			"   lsp code_action",
-- 		},
--
-- 		["gr"] = {
-- 			function()
-- 				vim.lsp.buf.references()
-- 			end,
-- 			"   lsp references",
-- 		},
--
-- 		["<leader>f"] = {
-- 			function()
-- 				vim.diagnostic.open_float()
-- 			end,
-- 			"   floating diagnostic",
-- 		},
--
-- 		["[d"] = {
-- 			function()
-- 				vim.diagnostic.goto_prev()
-- 			end,
-- 			"   goto prev",
-- 		},
--
-- 		["d]"] = {
-- 			function()
-- 				vim.diagnostic.goto_next()
-- 			end,
-- 			"   goto_next",
-- 		},
--
-- 		["<leader>q"] = {
-- 			function()
-- 				vim.diagnostic.setloclist()
-- 			end,
-- 			"   diagnostic setloclist",
-- 		},
--
-- 		["<leader>fm"] = {
-- 			function()
-- 				vim.lsp.buf.formatting()
-- 			end,
-- 			"   lsp formatting",
-- 		},
--
-- 		["<leader>wa"] = {
-- 			function()
-- 				vim.lsp.buf.add_workspace_folder()
-- 			end,
-- 			"   add workspace folder",
-- 		},
--
-- 		["<leader>wr"] = {
-- 			function()
-- 				vim.lsp.buf.remove_workspace_folder()
-- 			end,
-- 			"   remove workspace folder",
-- 		},
--
-- 		["<leader>wl"] = {
-- 			function()
-- 				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 			end,
-- 			"   list workspace folders",
-- 		},
-- 	},
-- }

return M
