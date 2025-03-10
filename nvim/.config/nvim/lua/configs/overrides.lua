-- Overrides of native plugins

local M = {}

M.cmpSources = {
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
}

M.conform = {
  lsp_fallback = true,

  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "gofmt", "goimports" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    yaml = { "prettierd" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

M.telescope = {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    buffers = {
      theme = "dropdown",
      previewer = "true",
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer",
        },
      },
    },
  },
  defaults = {
    path_display = {
      "smart",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    file_ignore_patterns = {
      ".docker",
      ".git/",
      ".git\\",
      "yarn.lock",
      "go.sum",
      "go.mod",
      "tags",
      "mocks",
      "refactoring",
      "^.git/",
      "^./.git/",
      "^node_modules/",
      "node_modules\\",
      "^build/",
      "^dist/",
      "^target/",
      "^vendor/",
      "^lazy%-lock%.json$",
      "^package%-lock%.json$",
    },
    initial_mode = "insert",
    mappings = {
      i = {
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<Esc>"] = require("telescope.actions").close,
      },
    },
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
  extension_list = {
    --- nvchad defaults
    "themes",
    "terms",
    ---
    "fzf",
  },
}

M.treesitter = {
  auto_install = true,
  ensure_installed = {
    -- Go Lang
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
  tree_setter = { enable = true },
  indent = { enable = true },
  playground = { enable = true },
  autotag = { enable = true },
  autopairs = { enable = true },
  context_commentstring = { enable = true },
  highlight = { enable = true, use_languagetree = true },
  matchup = { enable = true },
  tree_docs = { enable = true },

  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },

  textsubjects = {
    enable = true,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },

  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["sA"] = "@parameter.inner",
      },
    },
  },

  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = 1000,
    query = {
      "rainbow-parens",
      html = "rainbow-tags",
      javascript = "rainbow-tags-react",
      tsx = "rainbow-tags",
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

return M
