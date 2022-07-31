local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- lspservers with default config
local servers = {
	"gopls",
	"jsonls",
	"marksman",
	"yamlls",
}

local lspconfig = require("lspconfig")
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		root_dir = vim.loop.cwd,
	})
end
