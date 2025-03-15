-- Overrides of native plugins

local M = {}

M.cmp = {
  sources = {
    {
      name = "nvim_lsp",
      -- This excludes "Text" type from being included:
      entry_filter = function(entry, _)
        return entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Text
      end,
    },
    {
      name = "buffer",
      -- It's necessary to specify excluding "Text" from the buffer as well:
      entry_filter = function(entry, _)
        return entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Text
      end,
    },
    { name = "path" },
    { name = "luasnip" },
  },
}

M.conform = {
  lsp_fallback = true,
  notify_on_error = true,
  notify_no_formatters = true,

  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "gofmt", "goimports", lsp_format = "fallback" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    yaml = { "prettierd" },
  },
}

M.treesitter = {
  auto_install = true,
  ensure_installed = {
    -- Go
    "go",
    "gomod",
    "gowork",
    "gosum",
    "gotmpl",

    -- Git
    "gitcommit",
    "git_config",
    "diff",

    -- Markdown
    "markdown",
    "markdown_inline",

    "bash",
    "dockerfile",
    "fish",
    "jq",
    "json",
    "json5",
    "lua",
    "luadoc",
    "regex",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
  ignore_install = {
    "c",
    "javascript",
  },
  autopairs = { enable = true },
  highlight = { enable = true },
  indent = { enable = true },
}

return M
