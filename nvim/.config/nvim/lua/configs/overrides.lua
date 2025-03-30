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
    go = { "gofmt", "goimports", lsp_format = "fallback" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    markdown = { "prettierd" },
    sql = { "sqlint" },
    sh = { "shfmt" },
    toml = { "taplo" },
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
    "sql",
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
  incremental_selection = {
    enable = true,
    keymaps = {
      -- mappings for incremental selection (visual mappings)
      init_selection = "gnn", -- maps in normal mode to init the node/scope selection
      node_incremental = "grn", -- increment to the upper named parent
      scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
      node_decremental = "grm", -- decrement to the previous node
    },
  },
  textobjects = {
    -- syntax-aware textobjects
    enable = true,
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["DF"] = "@function.outer",
        ["DF"] = "@class.outer",
      },
    },
    keymaps = {
      ["iL"] = {
        -- you can define your own textobjects directly here
        go = "(function_definition) @function",
      },
      -- or you use the queries from supported languages with textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["aC"] = "@class.outer",
      ["iC"] = "@class.inner",
      ["ac"] = "@conditional.outer",
      ["ic"] = "@conditional.inner",
      ["ae"] = "@block.outer",
      ["ie"] = "@block.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["is"] = "@statement.inner",
      ["as"] = "@statement.outer",
      ["ad"] = "@comment.outer",
      ["am"] = "@call.outer",
      ["im"] = "@call.inner",
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- Or you can define your own textobjects like this
        ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function",
          go = "(method_declaration) @function",
        },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
}

return M
