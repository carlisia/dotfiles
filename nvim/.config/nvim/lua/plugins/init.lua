--   @type NvPluginSpec[]
local overrides = require "configs.overrides"
local ufo_custom = require "configs.ufo"
local linterConfig = vim.fn.stdpath "config" .. "/lint"

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
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
      }

      local markdownlint = require("lint").linters.markdownlint
      markdownlint.args = {
        "--config=" .. linterConfig .. "/.markdownlint.yaml",
        "--stdin",
      }
      local yamllint = require("lint").linters.yamllint
      yamllint.args = {
        "-c" .. linterConfig .. "/.yamllint.yaml",
        "--stdin",
      }
    end,
  },
  { ---- my own config:
    "hrsh7th/nvim-cmp",
    event = "VimEnter",
    dependencies = {
      "hrsh7th/cmp-cmdline",
    },
    opts = require("configs.completion").cmp,
    require("configs.completion").config(),
  },
  -----END NATIVE PLUGINS----
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("noice").setup(require("configs.noice").config)
    end,
  },
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
            setopt = true,
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
    keys = ufo_custom.keys,
    event = "BufRead",
    config = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "2"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup(ufo_custom.config)
    end,
  },
  { "tpope/vim-dadbod" },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_use_nvim_notify = 1

      vim.g.db_ui_tmp_query_location = "~/code/queries"
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
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "CmdlineEnter" },
    ft = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  -- {
  --   "ray-x/navigator.lua",
  --   requires = {
  --     { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
  --     { "neovim/nvim-lspconfig" },
  --   },
  --   opts = {
  --     width = 0.7,
  --     lsp = {
  --       diagnostic = { enable = true },
  --       rename = { style = "floating-preview" },
  --     },
  --   },
  -- },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      "echasnovski/mini.pick",
    },
    cmd = {
      "Neogit",
    },
    config = function()
      require("neogit").setup()
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
    lazy = false,
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
      require("mini.surround").setup()
      -- require("mini.bufremove").setup()
      -- require("mini.git").setup()
      -- require("mini.tabline").setup()
      -- require("mini.trailspace").setup()
      -- require("mini.fuzzy").setup()
      -- require("mini.misc").setup()
    end,
  },
  {
    "isak102/ghostty.nvim",
    -- lazy = false,
    event = "VeryLazy",
    config = function()
      require("ghostty").setup()
    end,
  },
  {
    "bezhermoso/tree-sitter-ghostty",
    lazy = false,
    build = "make nvim_install",
  },
  -- leet --
  {
    "kawre/leetcode.nvim",
    lazy = false,
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("leetcode").setup {
        lang = "golang",
      }
    end,
  },
  --- Tools
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>yo",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>yw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "\\,",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    configs = function()
      require("yazi").setup()
    end,
  },
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()
    end,
  },
  {
    "anasinnyk/nvim-k8s-crd",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("k8s-crd").setup {
        cache_dir = "~/.cache/k8s-schemas/", -- Local directory relative to the current working directory
        k8s = {
          file_mask = nil,
        },
      }
    end,
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("yaml-companion").setup {
        lspconfig = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        },
      }
    end,
  },
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    config = function()
      require("outline").setup()
    end,
  },
  --- Markdown
  {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "md", "mdx" },
    cmd = "PasteImage",
    config = function()
      require("img-clip").setup {
        default = {
          dir_path = "assets",
          template = "![$FILE_NAME_NO_EXT]($FILE_PATH)",
          show_dir_path_in_prompt = true,
          use_cursor_in_template = false,
          insert_mode_after_paste = false,
          copy_images = true,
          download_images = true,
          drag_and_drop = {
            enabled = true,
            insert_mode = true,
          },
        },
        filetypes = {
          markdown = {
            url_encode_path = true,
            template = "![$FILE_NAME_NO_EXT]($FILE_PATH)",
            download_images = true,
            copy_images = true,
            drag_and_drop = {
              enabled = true,
              insert_mode = true,
            },
          },
        },
      }
    end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- latest release instead of latest commit
    cmd = "Obsidian",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("obsidian").setup(require("configs.obsidian").opts)
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
      "echasnovski/mini.icons",
    },
    config = function()
      require("render-markdown").setup(require("configs.render-markdown").opts)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
