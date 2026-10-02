-- Overrides of native plugins

local M = {}

M.conform = {
  lsp_fallback = true,
  notify_on_error = true,
  notify_no_formatters = true,

  formatters_by_ft = {
    bash = { "shfmt" },
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "gofmt", "goimports", "gci", lsp_format = "fallback" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    markdown = { "prettierd" },
    sql = { "sql_formatter" },
    mysql = { "sql_formatter" },
    sh = { "shfmt" },
    toml = { "taplo" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    yaml = { "prettierd" },
    fish = { "fish_indent" },
  },

  formatters = {
    gci = {
      args = {
        "write",
        "--section",
        "standard",
        "--section",
        "default",
        "--section",
        "prefix(github.com/gravitational/teleport)",
        "--custom-order",
        "$FILENAME",
      },
    },
    -- Dialect per buffer: the dadbod connection URL (b:db) when there is one,
    -- then the mysql filetype, else sqlite (what the dadbod connections mostly are).
    sql_formatter = {
      prepend_args = function(_, ctx)
        local dialects = {
          postgres = "postgresql",
          postgresql = "postgresql",
          mysql = "mysql",
          mariadb = "mariadb",
          sqlite = "sqlite",
        }
        local db = vim.b[ctx.buf].db
        local url = type(db) == "table" and db.db_url or db
        local scheme = type(url) == "string" and url:match "^(%a+):" or nil
        local lang = dialects[scheme]
          or (vim.bo[ctx.buf].filetype == "mysql" and "mysql")
          or "sqlite"
        return { "--language", lang }
      end,
    },
  },
}

-- nvim-treesitter main branch: only ensure_installed is read, by NvChad's :TSInstallAll.
-- Highlighting starts from NvChad's FileType autocmd; indent from utils/autocmds.lua.
M.treesitter = {
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
    "git_rebase",
    "gitignore",
    "diff",

    -- Markdown
    "markdown",
    "markdown_inline",

    -- Web
    "css",
    "html",
    "scss",
    "tsx",
    "typescript",

    "bash",
    "csv",
    "dockerfile",
    "fish",
    "jq",
    "json",
    "json5",
    "kdl",
    "lua",
    "luadoc",
    "make",
    "pem",
    "printf",
    "proto",
    "python",
    "query",
    "regex",
    "rust",
    "sql",
    "terraform",
    "toml",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
  },
}

return M
