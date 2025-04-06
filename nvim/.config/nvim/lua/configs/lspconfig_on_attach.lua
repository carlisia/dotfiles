local keys = require "utils.lsp_bindings_general"

local M = {}

M.on_attach = function(_, bufnr)
  -- Format on save unless excluded
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
    buffer = bufnr,
    callback = function()
      if vim.bo[bufnr].buftype ~= "" then
        return -- Don't run on special buffers like Outline, quickfix, etc.
      end

      local ft = vim.bo[bufnr].filetype
      local excluded_filetypes = require("utils.toggles").excluded_filetypes

      if not excluded_filetypes[ft] and vim.bo[bufnr].buftype == "" then
        local clients = vim.lsp.get_clients { bufnr = bufnr }
        if #clients > 0 then
          local ok, conform = pcall(require, "conform")
          if ok then
            conform.format {
              bufnr = bufnr,
              lsp_fallback = true,
              timeout_ms = 1000,
            }
          end
        end
      end
    end,
  })

  local function silent_bufnr(desc)
    return { buffer = bufnr, desc = desc }
  end

  local map = vim.keymap.set

  -- General Vim LSP keys
  local unpack = table.unpack or unpack
  for _, value in ipairs(keys.vim) do
    local lhs, func_str, desc = unpack(value)
    local rhs = load("return " .. func_str)()
    map("n", lhs, rhs, silent_bufnr(desc))
  end

  -- General LSP keys
  for key, entry in pairs(keys.lsp) do
    local command, description = entry[1], entry[2]
    local keybind = keys.lsp_keys[key]
    map("n", keybind, command, silent_bufnr(description))
  end

  -- Language-specific (Go)
  local ft = vim.bo[bufnr].filetype
  local function is_go()
    return ft == "go" or ft == "gomod" or ft == "gowork" or ft == "gosum" or ft == "gotmpl"
  end

  local hasgonvim, _ = pcall(require, "go")
  if is_go() and hasgonvim then
    local go_k = keys.go_keys
    local gonvim = keys.go.gonvim
    for key, lhs in pairs(go_k) do
      local entry = gonvim[key]
      if entry then
        map("n", lhs, entry[1], silent_bufnr(entry[2] or ""))
      end
    end
  end
end

return M
