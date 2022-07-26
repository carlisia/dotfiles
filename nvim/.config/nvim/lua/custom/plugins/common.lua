local map = vim.keymap.set

local M = {}

function M.lspconfig_setup()
	return "custom.plugins.lspconfig"
end

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
		code_action = "<leader>ca",
		references = "gr",
		formatting = "<leader>fm",
		-- diagnostics
		workspace_diagnostics = "<leader>q",
		buffer_diagnostics = "ge",
		goto_prev = "[d",
		goto_next = "]d",
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
			vim.notify("No diagnostics found.")
		end
	end)

	buf_k("n", m.buffer_diagnostics, function()
		if vim.diagnostic.get()[1] then
			require("trouble").open("document_diagnostics")
		else
			vim.notify("No diagnostics found.")
		end
	end)

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

function M.searchbox()
	-- search
	map("n", "<leader>s", "<cmd>lua require('searchbox').match_all({confirm = 'menu'})<CR>")
	map("x", "<leader>s", "\"yy<cmd>lua require('custom.utils').search()<CR>")

	-- search and replace
	map("n", "<leader>r", "<cmd>lua require('searchbox').replace({confirm = 'menu'})<CR>")
	map("x", "<leader>r", "\"yy<cmd>lua require('custom.utils').search_and_replace()<CR>")
end

return M
