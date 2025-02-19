---@type NvPluginSpec[]

local overrides = require "configs.overrides"

return {
  -- Overrides of native plugins
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      enabled = false,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "overrides.conform",
  },
  -----END NATIVE PLUGINS----

  ---LANGUAGE
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  ---END OF LANGUAGE

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    -- lazy = false,
    config = function()
      require "configs.neotree"
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      -- to disable nvim-tree key mappings completly so neotree keybindings can work:
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = require("configs.snacks").opts,
    keys = require("configs.snacks").keys,

  -- leet --
  {
    "kawre/leetcode.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      arg = "leetcode.nvim",
      lang = "go",
    },
  },
}
