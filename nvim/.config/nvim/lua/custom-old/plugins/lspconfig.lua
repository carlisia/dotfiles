-- local on_attach = require("plugins.configs.lspconfig").on_attach
-- local capabilities = require("plugins.configs.lspconfig").capabilities

-- local lspconfig = require "lspconfig"

-- lspservers with default config
-- local servers = {
-- 		"bashls",
-- 		"gopls",
-- 		"jsonls",
-- 		"marksman",
-- 		"yamlls"
-- }

-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     root_dir = vim.loop.cwd,
--   }
-- end

---------|||||||||||||||||||||||||||||||||||||||||||

local test
local setup_lsp = function()
  require("base46").load_highlight "lsp"
  require "nvchad_ui.lsp"

   local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" } ,
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }

  local on_attach = function(client, bufnr)
    if client.name == "html" or client.name == "sumneko_lua" then
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
    require("custom.mappings").lspconfig(client, bufnr)

    if client.server_capabilities.signatureHelpProvider then
      require("nvchad_ui.signature").setup(client)
    end
  end
  local lspconfig = require "lspconfig"

  -- lspservers with default config

	-- local servers = {
	-- 	"bashls",
	-- 	"gopls",
	-- 	"jsonls",
	-- 	"marksman",
	-- 	"yamlls"
	-- }

  -- for _, lsp in ipairs(servers) do
  --   lspconfig[lsp].setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     -- root_dir = vim.loop.cwd,
  --     flags = {
  --       debounce_text_changes = 200,
  --     },
  --   }
  -- end

  local lua_lsp_config = {
    cmd = { "lua-language-server" },
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 300,
    },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        runtime = {
          version = "LuaJIT",
          -- path = runtime_path,
        },
        workspace = {
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }

  local neovim_parent_dir = vim.fn.resolve(vim.fn.stdpath "config")
  local neovim_local_dir = vim.fn.resolve(vim.fn.stdpath "data")
  local cwd = vim.fn.getcwd()
  -- is this file in the config directory?
  -- if neovim_parent_dir == cwd then
  if string.match(cwd, neovim_parent_dir) or string.match(cwd, neovim_local_dir) then
    local ok, lua_dev = pcall(require, "lua-dev")
    if ok then
      local luadev = lua_dev.setup {
        library = {
          vimruntime = true, -- runtime path
          types = true,
          plugins = false,
          -- you can also specify the list of plugins to make available as a workspace library
          -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
        runtime_path = true, -- enable this to get completion in require strings. Slow!
      }
      lua_lsp_config = vim.tbl_deep_extend("force", luadev, lua_lsp_config)
    end
  end
  lspconfig.sumneko_lua.setup(lua_lsp_config)
end

local M = {}
M.setup = function()
  setup_lsp()
end

M.setup()

