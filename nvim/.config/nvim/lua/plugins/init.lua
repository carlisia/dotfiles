--   @type NvPluginSpec[]
local overrides = require "configs.overrides"

return {
  -- Overrides of native plugins
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      return overrides.telescope
    end,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return overrides.treesitter
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = function()
      return overrides.conform
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function()
      return {
        icons = {
          group = "",
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  -----END NATIVE PLUGINS----

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
    version = false,
    config = function()
      -- text editing
      require("mini.ai").setup(require("configs.mini").ai)
      require("mini.comment").setup(require("configs.mini").comment)
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
      require("mini.clue").setup(require("configs.mini").clue)
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
      require("mini.misc").setup()
      require("mini.starter").setup()
      require("mini.sessions").setup(require("configs.mini").sessions)
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

  "chrisgrieser/nvim-recorder",
  keys = { "q", "Q" },
  opts = {
    slots = { "a", "b", "c", "d", "e", "f", "g" },
    mapping = {
      startStopRecording = "q",
      playMacro = "Q",
      editMacro = "<leader>qe",
      switchSlot = "<leader>qt",
    },
    lessNotifications = true,
    clear = false,
    logLevel = vim.log.levels.INFO,
    dapSharedKeymaps = false,
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
