---@type NvPluginSpec[]

local overrides = require "configs.overrides"

return {
-- Overrides of native plugins
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
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
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  -----END NATIVE PLUGINS----

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
    }
},

  -- Neo-tree is a Neovim plugin to browse the file system and other tree like
  -- structures in whatever style suits you, including sidebars, floating windows,
  -- netrw split style, or all of them at once!
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
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
