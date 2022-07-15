-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- Overriding LunarVim's default keybindings
local keybinding_prefix = lvim.keys.normal_mode
keybinding_prefix["<C-s>"] = ":w<cr>"

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

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
-- Builtins
lvim.builtin.notify.active = true

-- Indent Blankline settings
lvim.builtin.indent_blankline = {
  buftype_exclude = { "terminal" },
  filetype_exclude = { "dashboard", "NvimTree", "packer", "lsp-installer" },
  show_current_context = true,
  context_patterns = {
    "class", "return", "function", "method", "^if", "^while", "jsx_element", "^for", "^object",
    "^table", "block", "arguments", "if_statement", "else_clause", "jsx_element",
    "jsx_self_closing_element", "try_statement", "catch_clause", "import_statement",
    "operation_type"
  }
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
  {
    "Mofiqul/trld.nvim",
    config = function()
      require('trld').setup {
        -- where to render the diagnostics. 'top' | 'bottom'
        position = 'top',

        -- if this plugin should execute it's builtin auto commands
        auto_cmds = true,

        -- diagnostics highlight group names
        highlights = {
          error = "DiagnosticFloatingError",
          warn = "DiagnosticFloatingWarn",
          info = "DiagnosticFloatingInfo",
          hint = "DiagnosticFloatingHint",
        },
        formatter = function(diag)
          local u = require 'trld.utils'
          local diag_lines = {}

          for line in diag.message:gmatch("[^\n]+") do
            line = line:gsub('[ \t]+%f[\r\n%z]', '')
            table.insert(diag_lines, line)
          end

          local lines = {}
          for _, diag_line in ipairs(diag_lines) do
            table.insert(lines, { { diag_line .. ' ', u.get_hl_by_serverity(diag.severity) } })
          end

          return lines
        end,
      }
    end,
  },
  {
    -- smooth scrolling
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
      })
    end
  },
  {
    -- Markers in margin. 'ma' adds marker
    "kshenoy/vim-signature",
    event = "BufRead",
  },
  {
    -- Highlight URL's. http://www.vivaldi.com
    "itchyny/vim-highlighturl",
    event = "BufRead",
  },
  {
    -- Dev docs
    "rhysd/devdocs.vim"
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
  { "jesseduffield/lazygit" },
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
}
