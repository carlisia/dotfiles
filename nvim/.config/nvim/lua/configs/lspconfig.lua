-- [nvim-lspconfig/doc/configs.md at master · neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)

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
  init_options = {
    usePlaceholders = true,
  },
}

local sqlls = {
  filetypes = { "sql", "mysql", "plsql" },
}

servers["gopls"] = gopls
servers["sqlls"] = sqlls
servers["marksman"] = {}
servers["taplo"] = {}
servers["yamlls"] = {
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/kedro-org/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"] = "conf/**/*catalog*",
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
}

servers["jsonls"] = {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
      },
      validate = { enable = true },
    },
  },
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.capabilities = configs.capabilities

  opts.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  require("lspconfig")[name].setup(opts)
end
