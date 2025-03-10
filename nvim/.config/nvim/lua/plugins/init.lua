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
    opts = function(_, conf)
      conf.pickers = overrides.telescope.pickers
      conf.defaults = overrides.telescope.defaults
      conf.extension_list = overrides.extension_list
      conf.extensions = overrides.extensions

      return conf
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
    event = "BufWritePre", -- for format on save
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
  {
    "hrsh7th/nvim-cmp",
    require("cmp").setup {
      enabled = function()
        require("utils.plugins").disable_cmp_in_comments()
      end,
    },

    -- Because these opts uses a function call ex: require*,
    -- then make opts spec a function
    opts = function(_, conf)
      conf.sources = overrides.cmpSources
      return conf
    end,
  },

  -----END NATIVE PLUGINS----
  {
    "kevinhwang91/nvim-ufo",
    -- dependencies = { "kevinhwang91/promise-async" },
    dependencies = {
      { "kevinhwang91/promise-async" },
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            -- foldfunc = "builtin",
            -- setopt = true,
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    event = "BufRead",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
      },
    },
    config = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup {
        close_fold_kinds_for_ft = {
          default = { "imports", "comment" },
          json = { "array" },
          c = { "comment", "region" },
        },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      }
    end,
  },
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

  {
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
