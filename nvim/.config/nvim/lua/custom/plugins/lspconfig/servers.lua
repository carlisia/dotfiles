local servers = {

  --- example ---
  -- ["bashls"] = { config = function or table , disable_format = true or false }
  -- no need to specify config and disable_format is no changes are required
  ["bashls"] = {},
  ["jsonls"] = {},
  ["dockerls"] = {},
  ["marksman"] = {},
}

--- These below needs some extra stuff done do their default config

-- lua
servers["sumneko_lua"] = {
  config = function()
    local lua_lsp_config = {
      cmd = { "lua-language-server" },
      flags = { debounce_text_changes = 300 },
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          runtime = { version = "LuaJIT" },
          workspace = { maxPreload = 10000, preloadFileSize = 5000 },
          telemetry = { enable = false },
        },
      },
    }

    local neovim_config_dir = vim.fn.resolve(vim.fn.stdpath("config"))
    local neovim_local_dir = vim.fn.resolve(vim.fn.stdpath("data"))
    local cwd = vim.fn.getcwd()
    -- is this file in the config directory?
    -- if neovim_parent_dir == cwd then
    if string.match(cwd, neovim_config_dir) or string.match(cwd, neovim_local_dir) then
      local ok, lua_dev = pcall(require, "lua-dev")
      if ok then
        local luadev = lua_dev.setup({
          library = {
            vimruntime = true, -- runtime path
            types = true,
            plugins = false,
            -- you can also specify the list of plugins to make available as a workspace library
            -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
          },
          runtime_path = true, -- enable this to get completion in require strings. Slow!
        })
        lua_lsp_config = vim.tbl_deep_extend("force", luadev, lua_lsp_config) or {}
      end
    end
    return lua_lsp_config
  end,
  disable_format = true,
}

-- golang
servers["gopls"] = {
  config = function()
    local util = require("lspconfig/util")
    local go_lsp_config = {
      cmd = { "gopls", "serve" },
      filetypes = { "go", "gomod" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
      settings = {
        gopls = {
          analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          experimentalPostfixCompletions = true,
          gofumpt = true,
          staticcheck = true,
          usePlaceholders = true,
          shadow = true,
        },
      },
    }
    return go_lsp_config
  end,
  disable_format = true,
}

servers["marksman"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

servers["yamlls"] = {
  config = function()
    local yaml_lsp_config = {
      filetypes = { "yaml", "yml" },
      settings = {
        yaml = {
          format = { enabled = false },
          validate = true, -- TODO: conflicts between Kubernetes resources and kustomization.yaml
          completion = true,
          hover = true,
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemas = {
            -- TODO: add schemas for the other k8s resources if snippets don't validate well
            ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.20.5-standalone-strict/_definitions.json#/definitions/io.k8s.api.apps.v1.DaemonSet"] = "*/*.yaml",

            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
            -- ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
            ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
            ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
          },
        },
      },
    }
    return yaml_lsp_config
  end,
  disable_format = true,
}

servers["bashls"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

return servers
