local k = require("utils.custom_bindings").lsp
local vk = require("utils.custom_bindings").vim
local ob_k = require("utils.markdown_bindings").obsidian_workflow

-- Adapted from: https://github.com/desdic/neovim/blob/e22e397238bc8a53e2bbff885992756e99067014/lua/core/lspkeymaps.lua
local M = {}

M.setkeys = function(ev)
  local silent_bufnr = function(desc)
    return { silent = false, buffer = ev.buf, desc = desc }
  end

  require("utils.format").on_attach(ev, ev.buf)
  local format = require("utils.format").format
  local map = vim.keymap.set
  local ft = vim.bo.ft

  map("n", k.toggle_outline, "<cmd>Outline<cr>", silent_bufnr "Toggle 'package outline'")
  map("n", k.toggle_format_os, require("utils.format").toggle, { desc = "Toggle 'format on save'" })

  ---- lsp
  map("n", vk.code_action, vim.lsp.buf.code_action, { desc = "Code action" })
  map("n", vk.diagnostics_buffer, vim.diagnostic.setloclist, { desc = "Buffer diagnostics" })
  map("n", vk.hover, vim.lsp.buf.hover, silent_bufnr "Hover")
  map("n", vk.lsp_rename, require "nvchad.lsp.renamer", silent_bufnr "Rename identifier under cursor")

  map("n", vk.diag_go_next, vim.diagnostic.goto_next, silent_bufnr "Next diagnostic")
  map("n", vk.diag_go_prev, vim.diagnostic.goto_prev, silent_bufnr "Prev diagnostic")

  -- Check if we have capability
  local has_cap = function(cap)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return false
    end
    return client.server_capabilities[cap .. "Provider"]
  end

  if has_cap "signatureHelp" then
    map("n", vk.signature, vim.lsp.buf.signature_help, silent_bufnr "Signature")
  end

  if has_cap "documentFormatting" then
    map("n", k.format, format, silent_bufnr "Format file")
  end

  -- configure exceptions --
  local is_go = function(filetype)
    if
      filetype == "go"
      or filetype == "gomod"
      or filetype == "gowork"
      or filetype == "gosum"
      or filetype == "gotmpl"
    then
      return true
    end
    return false
  end

  local is_md = function(filetype)
    if filetype == "markdown" or filetype == "markdown_inline" then
      return true
    end
    return false
  end

  local hasgonvim, _ = pcall(require, "go")
  local hasobsidian, _ = pcall(require, "obsidian")
  if is_go(ft) and hasgonvim then -- map all the especialized go cmds:
    local go_k = require("utils.custom_bindings").go
    local subcategory_key = "gonvim"

    for _, subcategories in pairs(go_k) do
      local mappings = subcategories[subcategory_key] -- Ensure we only access the specified subcategory
      if mappings then
        for key, entry in pairs(mappings) do
          if type(entry) == "table" and entry[1] then
            local command = entry[1] -- Command
            local description = entry[2] or "No description" -- Description (optional fallback)
            map("n", "<leader>" .. key, command, silent_bufnr(description))
          end
        end
      end
    end
    --- toggles
    map("n", k.toggle_inlay_hints, "<cmd>GoToggleInlay<cr><cmd>redrawstatus<cr>", silent_bufnr "Toggle 'inlay hints'")
    map("n", k.toggle_test_imp, "<cmd>GoAlt<cr>", silent_bufnr "Toggle 'test/implementation'")
    map("n", k.toggle_outline, "<cmd>GoPkgOutline<cr>", silent_bufnr "Toggle 'package outline'")
  elseif is_md(ft) and hasobsidian then
    for key, value in pairs(ob_k) do
      local command, description = value[1], value[2]
      map("n", "<leader>" .. key, command, silent_bufnr(description))
    end
  end

  -- For everything else...
  local hassnacks, snacks = pcall(require, "snacks")
  if hassnacks then
    -- Search:
    map("n", k.diagnostics, function()
      snacks.picker.diagnostics()
    end, silent_bufnr "Code diagnostics")
    --- LSP:
    map("n", k.declaration, function()
      snacks.picker.lsp_declarations()
    end, silent_bufnr "Declaration")
    map("n", k.definition, function()
      snacks.picker.lsp_definitions()
    end, silent_bufnr "Definition")
    map("n", k.implementation, function()
      snacks.picker.lsp_implementations()
    end, silent_bufnr "Implementation")
    map("n", k.references, function()
      snacks.picker.lsp_references()
    end, silent_bufnr "References")
    map("n", k.symbols, function()
      snacks.picker.lsp_symbols()
    end, silent_bufnr "Symbols")
    map("n", k.type_definition, function()
      snacks.picker.lsp_type_definitions()
    end, silent_bufnr "Type definition")
    map("n", k.ws_symbols, function()
      snacks.picker.lsp_workspace_symbols()
    end, silent_bufnr "Workspace symbols")
  end
end

return M
