-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.auto_complete = true
lvim.termguicolors = true
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- ToggleTerm settings
local terminal_prefix = lvim.builtin.terminal
terminal_prefix.active = true
terminal_prefix.direction = "horizontal"
terminal_prefix.size = 10

local alpha_prefix = lvim.builtin.alpha
alpha_prefix.active = true
alpha_prefix.mode = "dashboard"
alpha_prefix.dashboard.section.header.opts.hl = ""
alpha_prefix.dashboard.section.header.val = {
  "▌              ▌ ▌▗",
  "▌  ▌ ▌▛▀▖▝▀▖▙▀▖▚▗▘▄ ▛▚▀▖",
  "▌  ▌ ▌▌ ▌▞▀▌▌  ▝▞ ▐ ▌▐ ▌",
  "▀▀▘▝▀▘▘ ▘▝▀▘▘   ▘ ▀▘▘▝ ▘",
}


alpha_prefix.dashboard.section.buttons.entries = {
  { "SPC f", "  Find File", "<CMD>Telescope find_files<CR>" },
  { "SPC n", "  New File", "<CMD>ene!<CR>" },
  { "SPC p", "  Recent Projects ", "<CMD>Telescope projects<CR>" },
  { "SPC u", "  Recently Used Files", "<CMD>Telescope oldfiles<CR>" },
  { "SPC s", "  Load last session", "<CMD>SessionLoad<CR>" },
  { "SPC r", "  Ranger", "<CMD>RnvimrToggle<CR>" },
  { "SPC m", "  Marks              ", "<CMD>Telescope marks<CR>" },
  { "SPC w", "  Find Word", "<CMD>Telescope live_grep<CR>" },
  { "SPC c", "  Edit Configuration", "<CMD>e ~/.config/lvim/config.lua<CR>" },
  { "SPC g", "  Git status", "<CMD>Telescope git_status<CR>" }
}

-- Language parsers
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "go",
  "json",
  "lua",
  "markdown",
  "python",
  "typescript",
  "yaml",
}

lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.context_commentstring.enable = true
lvim.builtin.treesitter.context_commentstring.enable_autocmd = true

-- vim.diagnostic.config({ virtual_text = false })

lvim.builtin.gitsigns.opts.signs.add.text = ''
lvim.builtin.gitsigns.opts.signs.change.text = ''
lvim.builtin.gitsigns.opts.signs.delete.text = ''
lvim.builtin.gitsigns.opts.signs.topdelete.text = ''
lvim.builtin.gitsigns.opts.signs.changedelete.text = ''

lvim.lsp.diagnostics.signs.values = {
  { name = "LspDiagnosticsSignError", text = "" },
  { name = "LspDiagnosticsSignWarning", text = "" },
  { name = "LspDiagnosticsSignHint", text = '' },
  { name = "LspDiagnosticsSignInformation", text = "" },
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  pcall(telescope.load_extension, "telescope-fzy-native")
  pcall(telescope.load_extension, "telescope-project")
  -- any other extensions loading
end

local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  --   -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- COLORS -----------------------------------

lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.options.theme = "powerline_dark"
local components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_b = {
  components.branch,
  "diff",
}
lvim.builtin.lualine.sections.lualine_c = { "filename" }
lvim.builtin.lualine.sections.lualine_x = {
  components.diagnostics,
  components.progress,
}
lvim.builtin.lualine.sections.lualine_y = {
  components.spaces,
  components.lsp,
}



-- NVIMTREE
-- https://github.com/kyazdani42/nvim-tree.lua
-- TODO: configure the core plugins in separate files
-- lvim.builtin.nvimtree.setup.filters.dotfiles = true
-- lvim.builtin.nvimtree.setup.open_on_tab = true

lvim.builtin.nvimtree.setup.view.side = "left"

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- Builtins
lvim.builtin.notify.active = true

-- Indent Blankline settings
lvim.builtin.indent_blankline = {
  buftype_exclude = { "terminal" },

  -- filetype_exclude = { "dashboard", "NvimTree", "packer", "lsp-installer" },
  show_current_context = true,
  -- context_patterns = {
  --   "class", "return", "function", "method", "^if", "^while", "jsx_element", "^for", "^object",
  --   "^table", "block", "arguments", "if_statement", "else_clause", "jsx_element",
  --   "jsx_self_closing_element", "try_statement", "catch_clause", "import_statement",
  --   "operation_type"
  -- }
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}


-- Additional Plugins
lvim.plugins = {
  -- CODE
  {
    "is0n/jaq-nvim",
    config = function()
      require('jaq-nvim').setup({
        cmds = {
          -- Uses vim commands
          internal = {
            lua = "luafile %",
            vim = "source %",
          },

          -- Uses shell commands
          external = {
            markdown = "glow %",
            python   = "python3 %",
            go       = "go run %",
            sh       = "/usr/local/bin/bash %",
          },
        },
      })
    end,
  },

  -- COLOR
  { "lunarvim/colorschemes" },
  {
    "christianchiarulli/nvcode-color-schemes.vim",
    config = function()
      require('config.color_nvcode-color-schemes')
    end,
  },
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },


  -- EDITOR
  {
    -- https://github.com/ggandor/lightspeed.nvim
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  {
    -- smooth scrolling
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('config.editor_neoscroll')
    end,
  },

  -- GIT
  {
  "sindrets/diffview.nvim",
  event = "BufRead",
},
  {
    'ldelossa/gh.nvim',
    requires = { 'ldelossa/litee.nvim' },
  },
  {
    -- https://github.com/ruifm/gitlinker.nvim
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    event = "BufRead",
    config = function()
      require("gitlinker").setup {
        opts = {
          mappings = "<leader>gy",
        },
      }
    end,
  },
  { "jesseduffield/lazygit" },
  {
    "pwntester/octo.nvim",
    event = "BufRead",
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('config.git_octo')
    end
  },

  -- LANGUAGES
  {
    "ray-x/go.nvim",
    config = function()
      require('config.lang_go')
    end,
  },
  {
    'ray-x/navigator.lua',
    requires = {
      'ray-x/guihua.lua', run = 'cd lua/fzy && make',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('config.lang_navigator')
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-refactor' },


  -- UTILS
  {
    -- Dev docs
    "rhysd/devdocs.vim"
  },

  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require('config.util_todo')
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },
  {
    "Mofiqul/trld.nvim",
    config = function()
      require('config.util_trld')
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require('config.util_trouble')
    end,
  },
  {
    -- Highlight URL's. http://www.vivaldi.com
    "itchyny/vim-highlighturl",
    event = "BufRead",
  },
  {
    -- Markers in margin. 'ma' adds marker
    "kshenoy/vim-signature",
    event = "BufRead",
  },


  -- TODO: refactor out configs
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    requires = {
      -- TODO: check if this is missing or if it's interfeering with builtin fzf when it's on
      { 'junegunn/fzf', run = function()
        vim.fn['fzf#install']()
      end
      },
      { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
    },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  {
    -- jump to the line
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
  },
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
        zindex = 20,
      }
    end
  },
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    config = function()
      vim.cmd [[packadd telescope.nvim]]
    end,
  },
}
