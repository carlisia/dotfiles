local configs = require "nvchad.configs.lspconfig"

local servers = {}
local gopls = {
  -- https://github.com/golang/tools/blob/3e76cae71578160dca62d1cab42a715ef960c892/gopls/doc/settings.md
  -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
  settings = {
    gopls = { -- overriding defaults only
      analyses = {
        shadow = true,
      },
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
servers["gopls"] = gopls

local cust_attach = function(_, bufnr)
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

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = cust_attach
  opts.capabilities = configs.capabilities

  require("lspconfig")[name].setup(opts)
end
