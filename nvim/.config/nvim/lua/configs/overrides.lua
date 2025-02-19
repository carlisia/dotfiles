-- Overrides of native plugins

local M = {}

M.telescope = {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
      },
    },
  },
  defaults = {
    path_display = {
      -- "smart",
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
  },
  mappings = {
    n = {
      ["q"] = require("telescope.actions").close,
      ["<Esc>"] = require("telescope.actions").close,
    },
  },
  layout_config = {
    horizontal = {
      prompt_position = "bottom",
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
  extension_list = { "fzf" },
}

M.treesitter = {
  auto_install = true,
  ensure_installed = {
    -- Go Lang
    "go",
    "gomod",
    "gowork",
    "gosum",

    -- Git
    "gitcommit",
    "git_config",
    "diff",

    -- Markdown
    "markdown",
    "markdown_inline",

    "vim",
    "lua",
    "luadoc",
    "bash",
    "json",
    "json5",
    "jq",
    "yaml",
    "dockerfile",
    "regex",
    "toml",
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

