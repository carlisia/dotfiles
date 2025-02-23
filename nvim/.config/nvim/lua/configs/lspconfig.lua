local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").on_capabilities

local lspconfig = require "lspconfig"
local servers = {
  "gopls",
  "lua_ls",
}

local cust_attach = function(client, bufnr)
  local map = vim.keymap.set

  map("n", "<leader>lr", require "nvchad.lsp.renamer", { buffer = bufnr, desc = "lsp renamer", noremap = true })

  map("n", "lD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "go to declaration", noremap = true })
  map("n", "ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "go to definition", noremap = true })
  map("n", "li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "go to implementation", noremap = true })
  map("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "signature", noremap = true })
  map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "add ws", noremap = true })
  map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "remove ws", noremap = true })

  map("n", "<leader>lwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { buffer = bufnr, desc = "list ws", noremap = true })

  map(
    "n",
    "<leader>lt",
    vim.lsp.buf.type_definition,
    { buffer = bufnr, desc = "go to type definition", noremap = true }
  )

  map({ "n", "v" }, "<leader>lc", vim.lsp.buf.code_action, { buffer = bufnr, desc = "code action", noremap = true })
  map("n", "lr", vim.lsp.buf.references, { buffer = bufnr, desc = "show references", noremap = true })

  map("n", "lb", "<cmd> Telescope<cr>", { buffer = bufnr, desc = "type definition", noremap = true })
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = cust_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end
