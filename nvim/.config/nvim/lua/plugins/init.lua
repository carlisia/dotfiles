local overrides = require "configs.overrides"

---@type NvPluginSpec[]
return {
  --------------------------------------- default plugins -----------------------------------------(siduck)
  -- https://github.com/siduck/dotfiles/blob/master/nvchad/lua/plugins/init.lua

  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
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

  -----END NATIVE PLUGINS----

  -- Neo-tree is a Neovim plugin to browse the file system and other tree like
  -- structures in whatever style suits you, including sidebars, floating windows,
  -- netrw split style, or all of them at once!
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    lazy = false,
    config = function()
      require "configs.neotree"
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      -- to disable nvim-tree key mappings completly so neotree keybindings can work:
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
  },

  {
    "neovim/nvim-lspconfig",

    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
      "kawre/leetcode.nvim",
      -- build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
      dependencies = {
          "nvim-telescope/telescope.nvim",
          -- "ibhagwan/fzf-lua",
          "nvim-lua/plenary.nvim",
          "MunifTanjim/nui.nvim",
      },
      cmd = "Leet",
      opts = {
          --@type lc.lang
          lang = "go",
      }
  },

  {
    "ggandor/leap.nvim",
    init = function()
      require("leap").add_default_mappings()
    end,
  },

  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      require("notify").setup({ timeout = 3000 })
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    after = "telescope.nvim",
    config = function()
      -- load extensions
      pcall(function()
        for _, ext in ipairs(require(overrides).telescope.extension_list) do
          require("telescope").load_extension(ext)
        end
      end)
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("telescope.nvim", 500)
    end,
  },

}
