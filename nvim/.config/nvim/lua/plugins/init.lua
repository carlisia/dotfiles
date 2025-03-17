--   @type NvPluginSpec[]
local overrides = require "configs.overrides"

return {
  -- Overrides of native plugins
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "nvim-tree/nvim-tree.lua", enabled = false },
  { "folke/which-key.nvim", enabled = false },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context", -- Show code context
        opts = {
          enable = true,
          mode = "topline",
          multiline_threshold = 40,
          separator = "-",
        },
      },
    },
    opts = function()
      return overrides.treesitter
    end,
  },
  {
    "stevearc/conform.nvim",
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
        require("utils.completion").disable_cmp_in_comments()
      end,
    },
    -- Because these opts uses a function call ex: require*,
    -- then make opts spec a function
    opts = function(_, conf)
      conf.sources = overrides.cmp.sources
      return conf
    end,
  },
  -----END NATIVE PLUGINS----

  {
    "folke/todo-comments.nvim",
    lazy = false,
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end,
    keys = {
      {
        "<leader>pc",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "List all comments",
      },
      {
        "<leader>pt",
        function()
          Snacks.picker.todo_comments { keywords = { "TODO" } }
        end,
        desc = "List TODO comments",
      },
      {
        "<leader>pf",
        function()
          Snacks.picker.todo_comments { keywords = { "FIX", "FIXME" } }
        end,
        desc = "List Fix/Fixme comments",
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
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
    keys = require("configs.ufo").keys,
    event = "BufRead",
    config = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup { require("configs.ufo").setup }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup(require("configs.go_plugins").govim)
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    opts = {
      dap_debug = true,
      dap_debug_gui = true,
      lsp_inlay_hints = { enable = true },
      diagnostic = true,
    },
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
      require("mini.ai").setup(require("configs.mini").ai)
      require("mini.basics").setup(require("configs.mini").basics)
      require("mini.bracketed").setup()
      require("mini.clue").setup(require("configs.mini").clue)
      require("mini.comment").setup(require("configs.mini").comment)
      require("mini.cursorword").setup()
      require("mini.diff").setup()
      require("mini.hipatterns").setup(require("configs.mini").hipatterns)
      require("mini.icons").setup()
      require("mini.indentscope").setup()
      require("mini.files").setup(require("configs.mini").files)
      require("mini.move").setup(require("configs.mini").move)
      require("mini.notify").setup()
      require("mini.operators").setup()
      require("mini.sessions").setup(require("configs.mini").sessions)
      require("mini.splitjoin").setup {
        mappings = {
          toggle = "\\k",
          split = "sk",
          join = "sj",
        },
      }
      require("mini.starter").setup()
      require("mini.surround").setup()
      -- require("mini.surround").setup(require("configs.mini").surround)
      -- require("mini.bufremove").setup()
      -- require("mini.git").setup()
      -- require("mini.hipatterns").setup()
      -- require("mini.tabline").setup()
      -- require("mini.trailspace").setup()
      -- require("mini.fuzzy").setup()
      -- require("mini.icons").setup():
      -- require("mini.misc").setup()
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
