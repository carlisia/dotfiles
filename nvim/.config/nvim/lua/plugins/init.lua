---@type NvPluginSpec[]

local overrides = require "configs.overrides"

return {
  -- Overrides of native plugins
  {
    enabled = false,
    "nvim-tree/nvim-tree.lua",
    opts = {
      enabled = false,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
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
    opts = overrides.conform,
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
    lazy = false,
    config = function()
      require "configs.neotree"
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      -- to disable nvim-tree key mappings completly so neotree keybindings can work:
      -- vim.g.neo_tree_remove_legacy_commands = 1
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = require("configs.snacks").opts,
    keys = require("configs.snacks").keys,
  },

  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      -- text editing
      require("mini.ai").setup(require("configs.mini").ai)
      require("mini.comment").setup()
      require("mini.completion").setup {
        delay = { completion = 10000, info = 100, signature = 50 },
      }
      require("mini.move").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup(require("configs.mini").surround)
      -- workflow
      require("mini.basics").setup()
      require("mini.bracketed").setup()
      require("mini.bufremove").setup()
      require("mini.clue").setup()
      require("mini.diff").setup()
      require("mini.files").setup(require("configs.mini").files)
      require("mini.git").setup()
      -- appearance
      require("mini.cursorword").setup()
      require("mini.hipatterns").setup()
      require("mini.indentscope").setup()
      require("mini.notify").setup()
      -- require("mini.tabline").setup()
      require("mini.trailspace").setup()
      -- others
      require("mini.fuzzy").setup()
      require("mini.icons").setup()
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    enabled = true,
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 1.0
    end,
  },

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
