return {
  --------------------------------------- default plugins -----------------------------------------(siduck)
  -- https://github.com/siduck/dotfiles/blob/master/nvchad/lua/plugins/init.lua

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "go",
        "json",
        "toml",
        "markdown",
        "c",
        "bash",
        "lua",
        "yaml",
        "vim",
      },
      autopairs = { enable = true },
      context_commentstring = { enable = true },
      highlight = { enable = true, use_languagetree = true },
      indent = { enable = true },
      matchup = { enable = true },
      tree_docs = { enable = true },

      autotag = {
        enable = true,
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
    },
  },

  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",

    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

}
