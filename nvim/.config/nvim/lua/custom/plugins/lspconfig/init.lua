-- no need to touch this file
-- only custom/plugins/lspconfig/servers.lua should be modified ideally
local loaded, lspconfig = pcall(require, "lspconfig")

if not loaded then
  return
end

local setup_lsp = function()
  pcall(function()
    require("base46").load_highlight "lsp"
  end)

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
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

  local s = require "custom.plugins.lspconfig.servers"
  for server, conf in pairs(s) do
    local name = server
    local disable_format = conf.disable_format or false
    local config = conf.config or {}
    local final_config = config

    if type(config) == "function" then
      final_config = config()
    end

    if not type(final_config) == "table" then
      vim.notify("custom/lspconfig.lua: final_config was not a table for " .. name)
      final_config = {}
    end

    local on_attach = function(client, bufnr)
      if disable_format then
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
      end

      require("custom.mappings").lspconfig(client, bufnr)

      local ok, signature = pcall(require, "lsp_signature")
      if ok then
        signature.on_attach({}, bufnr)
      end
    end

    local default_config = {
      on_attach = on_attach,
      capabilities = capabilities,
      -- root_dir = vim.loop.cwd,
      flags = {
        debounce_text_changes = 200,
      },
    }

    final_config = vim.tbl_deep_extend("force", default_config, final_config) or default_config
    lspconfig[name].setup(final_config)
  end
end

setup_lsp()
