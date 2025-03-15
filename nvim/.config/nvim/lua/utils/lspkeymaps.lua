local k = require("utils.custom_bindings").lsp

-- Adapted from: https://github.com/desdic/neovim/blob/e22e397238bc8a53e2bbff885992756e99067014/lua/core/lspkeymaps.lua
local M = {}

M.setkeys = function(ev)
  local silent_bufnr = function(desc)
    return { silent = true, buffer = ev.buf, desc = desc }
  end

  -- Check if we have capability
  local has_cap = function(cap)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return false
    end
    return client.server_capabilities[cap .. "Provider"]
  end

  require("utils.format").on_attach(ev, ev.buf)
  local format = require("utils.format").format

  local keymap = vim.keymap.set
  local ft = vim.bo.ft

  local is_go = function(filetype)
    if filetype == "go" or filetype == "gomod" or filetype == "gosum" then
      return true
    end
    return false
  end

  local hassnacks, snacks = pcall(require, "snacks")
  if hassnacks then
    keymap("n", k.definition, function()
      snacks.picker.lsp_definitions()
    end, silent_bufnr "Goto definition")
    keymap("n", k.implementation, function()
      snacks.picker.lsp_implementations()
    end, silent_bufnr "Goto Implementation")
    keymap("n", k.references, function()
      snacks.picker.lsp_references()
    end, silent_bufnr "References")
    keymap("n", k.type_definition, function()
      snacks.picker.lsp_type_definitions()
    end, silent_bufnr "Goto Type Definition")
    keymap("n", k.ws_symbols, function()
      snacks.picker.lsp_workspace_symbols()
    end, silent_bufnr "LSP finder")
    keymap("n", k.symbols, function()
      snacks.picker.lsp_symbols()
    end, silent_bufnr "lsp_symbols")
    keymap("n", k.diagnostics, function()
      snacks.picker.diagnostics()
    end, silent_bufnr "diagnostic")
  end

  keymap("n", k.format, require("utils.format").toggle, { desc = "Toggle 'format on save'" })
  keymap("n", k.declaration, vim.lsp.buf.declaration, silent_bufnr "Goto declaration")
  keymap("n", k.hover, vim.lsp.buf.hover, silent_bufnr "Hover")
  keymap("n", k.lsp_rename, vim.lsp.buf.rename, silent_bufnr "Rename")

  keymap("n", k.diag_go_next, vim.diagnostic.goto_next, silent_bufnr "Next Diagnostic")
  keymap("n", k.diag_go_prev, vim.diagnostic.goto_prev, silent_bufnr "Prev Diagnostic")

  if has_cap "signatureHelp" then
    keymap("n", k.signature, vim.lsp.buf.signature_help, silent_bufnr "Signature Help")
  end

  -- Preferences for code actions
  keymap({ "n", "v" }, "<leader>ca", function()
    if is_go(ft) then
      return vim.cmd "GoCodeAction"
    end
    return vim.lsp.buf.code_action()
  end, silent_bufnr "Code Action")

  keymap({ "n" }, "<leader>cl", function()
    if is_go(ft) then
      return vim.cmd "GoCodeLenAct"
    end
    return vim.lsp.codelens.run()
  end)

  if has_cap "documentFormatting" then
    keymap("n", "<leader>fm", format, silent_bufnr "[F]or[m]at Document")
  end

  keymap("n", "<leader>lh", function()
    local opt = { buf = 0 }
    local ok = pcall(vim.lsp.inlay_hint.enable, vim.lsp.inlay_hint.is_enabled(opt))
    if ok then
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(opt))
    else
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(opt), opt)
    end
  end, { desc = "LSP | Toggle Inlay Hints", silent = true })
end

return M
