return {
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  -- all of the lsp related stuff --
  ["neovim/nvim-lspconfig"] = {
    after = "mason.nvim",
    module = "lspconfig",
    config = function()
      require "custom.plugins.lspconfig"
    end,
  },

  ["williamboman/mason-lspconfig.nvim"] = { module = "mason-lspconfig" },

  ["williamboman/mason.nvim"] = {
    opt = true,
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("mason.nvim", 1000)
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
        vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
      end, 0)
    end,
  },

  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.common").lsp_signature()
    end,
  },

  ["glepnir/lspsaga.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("lspsaga").init_lsp_saga { max_preview_lines = 50 }
    end,
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.common").null_ls()
    end,
  },

  -- go lsp stuff
  ["crispgm/nvim-go"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.common").nvim_go()
    end,
    requires = "rcarriga/nvim-notify",
  },

  -- lua lsp stuff
  ["folke/lua-dev.nvim"] = { ft = "lua" },

  ["folke/trouble.nvim"] = {
    module = "trouble",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup { auto_close = true, use_diagnostic_signs = false }
    end,
  },
  -- lsp stuff end --
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------

  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup { mapping = { "jk", "JK", "Jk" } }
    end,
  },

  ["akinsho/bufferline.nvim"] = {
    config = function()
      require("custom.plugins.common").bufferline()
    end,
    after = "base46",
  },

  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
    config = function()
      require("custom.plugins.common").cmp()
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("nvim-cmp", 0)
    end,
  },

  ["stevearc/dressing.nvim"] = {
    opt = true,
    config = function()
      require("dressing").setup { input = { mappings = { n = { ["q"] = "Close" } } } }
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("dressing.nvim", 1000)
    end,
  },

  ["j-hui/fidget.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("fidget").setup {}
    end,
  },

  ["ggandor/lightspeed.nvim"] = {
    opt = true,
    config = function()
      require("lightspeed").setup { ignore_case = true, repeat_ft_with_target_char = true }
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("lightspeed.nvim", 1000)
    end,
  },

  ["danymat/neogen"] = {
    module = "neogen",
    cmd = "Neogen",
    config = function()
      require("neogen").setup { { snippet_engine = "luasnip" } }
    end,
    setup = function()
      require("custom.mappings").neogen()
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },

  ["nvim-neo-tree/neo-tree.nvim"] = {
    requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require "custom.plugins.neotree"
    end,
  },

  ["nacro90/numb.nvim"] = {
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },

  ["kevinhwang91/nvim-bqf"] = { ft = "qf" },

  ["rcarriga/nvim-notify"] = {
    config = function()
      vim.notify = require "notify"
      require("notify").setup { timeout = 3000 }
    end,
  },

  ["windwp/nvim-spectre"] = {
    module = "spectre",
    command = "FindReplace",
    config = function()
      require("spectre").setup { color_devicons = true, open_cmd = "vertical new", is_insert_mode = true }
    end,
    setup = function()
      require("custom.mappings").spectre()
      require("custom.commands").spectre()
    end,
  },

  ["olimorris/persisted.nvim"] = {
    config = function()
      require("custom.plugins.common").persisted()
    end,
  },

  ["tversteeg/registers.nvim"] = {
    config = function()
      vim.g.registers_window_border = "rounded"
      vim.g.registers_insert_mode = false -- Suppress imap <C-R>
      vim.cmd [[ inoremap <C-R> &ft=='TelescopePrompt' ? '<C-R>' : registers#peek('<C-R>') ]]
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("telescope.nvim", 1000)
    end,
  },

  ["VonHeikemen/searchbox.nvim"] = {
    module = "searchbox",
    command = "SearchBox",
    requires = { "MunifTanjim/nui.nvim" },
    setup = function()
      require("custom.mappings").searchbox()
    end,
  },

  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    run = "make",
    after = "telescope.nvim",
    config = function()
      -- load extensions
      pcall(function()
        for _, ext in ipairs(require("custom.plugins.common").telescope().extension_list) do
          require("telescope").load_extension(ext)
        end
      end)
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("telescope.nvim", 500)
    end,
  },

  ["akinsho/toggleterm.nvim"] = {
    module = "toggleterm",
    config = function()
      require("custom.plugins.common").toggleterm()
    end,
    setup = function()
      require("custom.mappings").toggleterm()
    end,
  },

  ["nvim-treesitter/nvim-treesitter-context"] = {
    after = "nvim-treesitter",
    config = function()
      require("treesitter-context").setup {
        enable = true,
        max_lines = 2,
        trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        patterns = { default = { "class", "function", "method", "for", "while", "if", "switch", "case" } },
      }
    end,
  },

  ["matze/vim-move"] = {
    opt = true,
    setup = function()
      require("custom.utils").packer_lazy_load("vim-move", 1000)
    end,
  },
}
