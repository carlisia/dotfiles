-- [nvim-lspconfig/doc/configs.md at master · neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
local configs = require "nvchad.configs.lspconfig"

local servers = {}

-- Clone `configs.capabilities` so it's not mutated, because Lua tables are reference-based:
local base_capabilities = vim.deepcopy(configs.capabilities)
-- Helper to optionally extend capabilities per server
local function with_capabilities(custom)
  return vim.tbl_deep_extend("force", {}, base_capabilities, custom or {})
end

-- https://github.com/golang/tools/blob/3e76cae71578160dca62d1cab42a715ef960c892/gopls/doc/settings.md
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
require("go").setup(require("configs.go_plugins").govim)
servers["gopls"] = require("go.lsp").config()

servers["sqlls"] = {
  filetypes = { "sql", "mysql", "plsql" },
}

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

servers["marksman"] = {
  filetypes = { "markdown", "md", "mdx" },
  capabilities = with_capabilities {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
}

servers["taplo"] = {}

servers["lua_ls"] = {
  settings = {
    Lua = {
      hint = {
        enable = true,
        paramName = "All",
        paramType = true,
        setType = true,
        arrayIndex = "Auto",
        semicolon = "Disable",
      },
    },
  },
}

-- Use new vim.lsp.config API for Neovim 0.11+
for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.capabilities = opts.capabilities or base_capabilities

  local ok, err = pcall(function()
    vim.lsp.config(name, opts)
    vim.lsp.enable(name)
  end)

  if not ok then
    vim.notify("Failed to setup LSP '" .. name .. "': " .. tostring(err), vim.log.levels.WARN)
  end
end
