---@type {[PluginName]: NvPluginConfig|false}

local overrides = require "custom.plugins.overrides"

local plugins = {
  -- remove plugins --

  ["NvChad/nvterm"] = false,

  -- override plugin definition options --

  ["neovim/nvim-lspconfig"] = {
    after = "mason.nvim",
    module = "lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },

  -- override plugin configs --

  ["NvChad/ui"] = {
    override_options = { tabufline = { enabled = false }, statusline = { separator_style = "arrow" } },
  },

  ["nvim-treesitter/nvim-treesitter"] = {
    setup = function()
      require "custom.plugins.treesitter"
    end,
    config = function() end,
  },

  ["williamboman/mason.nvim"] = {
    override_options = overrides.mason,
  },

  ["nvim-tree/nvim-tree.lua"] = {
    override_options = overrides.nvimtree,
  },

  -- install plugins --

  ["williamboman/mason-lspconfig.nvim"] = { module = "mason-lspconfig" },
  ["ray-x/lsp_signature.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.overrides").lsp_signature()
    end,
  },
  -- code formatting, linting etc
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.overrides").null_ls()
    end,
  },
  ["glepnir/lspsaga.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("lspsaga").setup({
        max_preview_lines = 50,
        diagnostic_header = { "😡", "😥", "😤", "😐" },
      })
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
  -- Neo-tree is a Neovim plugin to browse the file system and other tree like
  -- structures in whatever style suits you, including sidebars, floating windows,
  -- netrw split style, or all of them at once!
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  ["nvim-neo-tree/neo-tree.nvim"] = {
    requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("custom.plugins.neotree")
      require("custom.keybindings").neotree()
    end,
  },

  -- A better annotation generator. Supports multiple languages and annotation conventions
  -- https://github.com/danymat/neogen
  ["danymat/neogen"] = {
    -- module = "neogen",
    -- cmd = "Neogen",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
    -- setup = function()
      -- require("custom.mappings").neogen()
    -- end,
  },

  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  ["mfussenegger/nvim-dap"] = {
    -- config = function()
    -- 	require("nvim-dap")
    -- end,
    -- setup = function()
    -- 	require("custom.extensions").packer_lazy_load("nvim-dap")
    -- end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    -- config = function()
    -- 	require("nvim-dap-ui")
    -- end,
    -- setup = function()
    -- 	require("custom.extensions").packer_lazy_load("nvim-dap-ui")
    -- end,
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    -- config = function()
    -- 	require("nvim-dap-virtual-text")
    -- end,
    -- setup = function()
    -- 	require("custom.extensions").packer_lazy_load("nvim-dap-virtual-text")
    -- end,
  },
  ["ray-x/guihua.lua"] = {
    run = "cd lua/fzy && make",
    setup = function()
      require("custom.utils").packer_lazy_load("guihua.lua")
    end,
  },

  ["RishabhRD/popfix"] = {
    setup = function()
      require("custom.utils").packer_lazy_load("popfix")
    end,
  },
  ["RishabhRD/nvim-cheat.sh"] = {
    setup = function()
      require("custom.utils").packer_lazy_load("nvim-cheat.sh")
    end,
  },

  ["folke/lua-dev.nvim"] = { ft = "lua" },

  ["folke/trouble.nvim"] = {
    module = "trouble",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({ auto_close = true, use_diagnostic_signs = false })
    end,
  },

  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({ mapping = { "jk", "JK", "KJ", "kj" } })
    end,
  },

  ["akinsho/bufferline.nvim"] = {
    config = function()
      require("custom.plugins.overrides").bufferline()
    end,
    after = "base46",
  },

  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
    config = function()
      require("custom.plugins.overrides").cmp()
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("nvim-cmp", 0)
    end,
  },

  ["stevearc/dressing.nvim"] = {
    opt = true,
    config = function()
      require("dressing").setup({ input = { mappings = { n = { ["q"] = "Close" } } } })
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("dressing.nvim", 1000)
    end,
  },

  -- ui for lsp progress
  ["j-hui/fidget.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("fidget").setup({})
    end,
  },

  ["ggandor/lightspeed.nvim"] = {
    opt = true,
    config = function()
      require("lightspeed").setup({ ignore_case = true, repeat_ft_with_target_char = true })
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("lightspeed.nvim", 1000)
    end,
  },

  ["nacro90/numb.nvim"] = {
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },

  ["kevinhwang91/nvim-bqf"] = { ft = "qf" },


  -- TODO: Fix the highlight issue:
  --[[
Highlight group 'Normal' has no background highlight
Please provide an RGB hex value or highlight group with a background value for 'background_colour' option.
This is the colour that will be used for 100% transparency.
```lua
require("notify").setup({
  background_colour = "#000000",
})
```
Defaulting to #000000
--]]
["rcarriga/nvim-notify"] = {
  config = function()
    vim.notify = require("notify")
    require("notify").setup({ timeout = 3000 })
  end,
},

["windwp/nvim-spectre"] = {
  module = "spectre",
  command = "FindReplace",
  config = function()
    require("spectre").setup({ color_devicons = true, open_cmd = "vertical new", is_insert_mode = true })
    require("custom.keybindings").spectre()
  end,
  setup = function()
    require("custom.commands").spectre()
  end,
},
["olimorris/persisted.nvim"] = {
  config = function()
    require("custom.plugins.overrides").persisted()
  end,
},

["tversteeg/registers.nvim"] = {
  config = function()
    vim.g.registers_window_border = "rounded"
    vim.g.registers_insert_mode = false -- Suppress imap <C-R>
    vim.cmd([[ inoremap <C-R> &ft=='TelescopePrompt' ? '<C-R>' : registers#peek('<C-R>') ]])
  end,
  setup = function()
    require("custom.utils").packer_lazy_load("telescope.nvim", 1000)
  end,
},

["VonHeikemen/searchbox.nvim"] = {
  module = "searchbox",
  command = "SearchBox",
  requires = { "MunifTanjim/nui.nvim" },
  config = function()
    require("custom.keybindings").searchbox()
  end,
},

["nvim-telescope/telescope.nvim"] = { override_options = require("custom.plugins.overrides").telescope() },

["nvim-telescope/telescope-fzf-native.nvim"] = {
  run = "make",
  after = "telescope.nvim",
  config = function()
    -- load extensions
    pcall(function()
      for _, ext in ipairs(require("custom.plugins.overrides").telescope().extension_list) do
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
    require("custom.plugins.overrides").toggleterm()
    require("custom.keybindings").toggleterm()
  end,
},


["matze/vim-move"] = {
  opt = true,
  setup = function()
    require("custom.utils").packer_lazy_load("vim-move", 1000)
  end,
},

["ruifm/gitlinker.nvim"] = {
  requires = "nvim-lua/plenary.nvim",
  event = "BufRead",
  config = function()
    require("gitlinker").setup({
      opts = {
        mappings = "<leader>gy",
      },
    })
  end,
  setup = function()
    require("custom.utils").packer_lazy_load("gitlinker.nvim")
  end,
},
["f-person/git-blame.nvim"] = {
  event = "BufRead",
  config = function()
    vim.cmd("highlight default link gitblame SpecialComment")
    vim.g.gitblame_enabled = 0
  end,
},
["sindrets/diffview.nvim"] = {
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
  },
  config = function()
    require("custom.plugins.overrides").diffview()
  end,
},
["folke/todo-comments.nvim"] = {
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("todo-comments").setup()
  end,
  setup = function()
    require("custom.utils").packer_lazy_load("todo-comments.nvim")
  end,
},
["mg979/vim-visual-multi"] = {
  setup = function()
    require("custom.utils").packer_lazy_load("vim-visual-multi")
  end,
},

----------
["itspriddle/vim-marked"] = {
  setup = function()
    require("custom.utils").packer_lazy_load("vim-marked")
  end,
},
["yamatsum/nvim-cursorline"] = {
  config = function()
    require("nvim-cursorline").setup({
      cursorline = {
        enable = true,
        timeout = 1000,
        number = true,
      },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    })
  end,
  setup = function()
    require("custom.utils").packer_lazy_load("nvim-cursorline")
  end,
},

["erietz/vim-terminator"] = {
  setup = function()
    require("custom.utils").packer_lazy_load("vim-terminator", 500)
  end,
},
["pwntester/octo.nvim"] = {
  after = "telescope.nvim",
  requires = {
    "kyazdani42/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    "nvim/telescope.nvim",
  },
  config = function()
    require("octo").setup()
  end,
  setup = function()
    require("custom.utils").packer_lazy_load("telescope.nvim", 500)
  end,
},
["petertriho/cmp-git"] = {
  after = "nvim-cmp",
  setup = function()
    require("custom.utils").packer_lazy_load("cmp-git")
  end,
},

["stevearc/aerial.nvim"] = {
  cmd = "AerialToggle",
  config = function()
    require("custom.plugins.overrides").aerial()
  end,
},
["tpope/vim-fugitive"] = {},
["tpope/vim-unimpaired"] = {},

["famiu/bufdelete.nvim"] = {
  module = "bufdelete",
  command = "Bufdelete",
  config = function()
    require("custom.keybindings").bufdelete()
  end,
},

["windwp/nvim-autopairs"] = { override_options = { check_ts = true } },
["NvChad/nvim-colorizer.lua"] = { override_options = require("custom.plugins.overrides").colorizer() },

["lukas-reineke/indent-blankline.nvim"] = require("custom.plugins.overrides").blankline,

["lewis6991/gitsigns.nvim"] = require("custom.plugins.overrides").gitsigns,

["ray-x/go.nvim"] = {
  config = function()
    require("custom.plugins.overrides").go_nvim()
  end,
  setup = function()
    require("custom.utils").packer_lazy_load("go.nvim")
  end,
},

  -- ["goolord/alpha-nvim"] = { disable = false } -- enables dashboard
}

return plugins
