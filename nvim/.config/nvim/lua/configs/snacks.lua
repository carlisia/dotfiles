Snacks = Snacks

local M = {}

M.opts = {
  dashboard = { enabled = false },
  toggle = { enabled = true },
  scroll = { enabled = true }, -- handles scrolloff and mouse scrolling
  indent = { enabled = true, chunk = { enabled = true, only_current = true } },

  -- bigfile adds a new filetype bigfile to Neovim that triggers when the file is larger than the configured size
  -- This automatically prevents things like LSP and Treesitter attaching to the buffer:
  bigfile = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    top_down = false, -- place notifications from top to bottom
  },
  quickfile = {
    enabled = true,
    -- any treesitter langs to exclude:
    exclude = { "latex" },
  },
  scope = { enabled = true },
  words = { enabled = true }, -- auto-show LSP references and quickly navigate between them
  git = { enabled = true },
  gitbrowse = { enabled = true },
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
  picker = {
    enabled = true,
    ignored = true,
    hidden = true,
    debug = { scores = true }, -- show scores in the list
    matcher = {
      cwd_bonus = true,
      frecency = true,
    },
    -- default config for all sources:
    -- https://github.com/folke/snacks.nvim/blob/main/lua/snacks/picker/config/sources.lua
    sources = {
      -- files and buffers explicitly set ignored and hidden (to false)
      files = { ignored = true, hidden = true },
      grep_buffers = { ignored = true, hidden = true },
      -- grep = { ignored = true, hidden = true },
      -- grep_word = { ignored = true, hidden = true },
      explorer = {
        debug = { scores = false }, -- show scores in the list
        layout = {
          preset = "sidebar",
          cycle = false,
        },
      },
    },
    ui_select = true, -- replace `vim.ui.select` with the snacks picker
    indent = { chunk = { enabled = true } },
    layout = {
      preset = "ivy",
      cycle = false,
      position = "bottom",
    },
    layouts = {
      -- Got example from here:
      -- https://github.com/folke/snacks.nvim/discussions/468
      ivy = {
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.3,
          border = "top",
          title = " {title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "bottom" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", width = 0.5, border = "left" },
          },
        },
      },
      -- To modify the layout width:
      vertical = {
        layout = {
          backdrop = false,
          width = 0.8,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          title_pos = "center",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
    },
    win = {
      input = {
        keys = {
          -- To close the picker on ESC instead of going to normal mode:
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          -- To scrolling like in the LazyGit preview:
          ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
          ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
        },
      },
    },
  },
}
M.keys = {
  ------- Main
  {
    "\\d",
    function()
      Snacks.explorer()
    end,
    desc = "Toggle 'snacks explorer",
  },
  {
    "<leader>:",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command history",
  },
  {
    "<leader>y",
    function()
      Snacks.bufdelete()
    end,
    desc = "Close buffer",
  },
  {
    "<leader>k",
    function()
      Snacks.picker.keymaps { layout = "ivy" }
    end,
    desc = "Keymaps",
  },
  {
    "<leader>h",
    function()
      Snacks.picker.help()
    end,
    desc = "Help pages",
  },

  ------- Scratch
  {
    "\\.",
    function()
      Snacks.scratch()
    end,
    desc = "Toggle 'scratch buffer'",
  },
  {
    "<leader>,",
    function()
      Snacks.scratch.select()
    end,
    desc = "Select scratch buffer",
  },
  {
    "<leader>t",
    function()
      Snacks.scratch { icon = " ", name = "Todo", ft = "markdown", file = "~/dot/TODO.md" }
    end,
    desc = "Todo List",
  },

  ------- Notifications
  {
    "<leader>nn",
    function()
      Snacks.notifier.show_history()
    end,
    desc = "Notifications",
  },
  {
    "<leader>ns",
    function()
      Snacks.picker.notifications()
    end,
    desc = "Notification history",
  },
  {
    "<leader>nh",
    function()
      Snacks.notifier.hide()
    end,
    desc = "Hide notifications",
  },

  {
    "<leader>sq",
    function()
      Snacks.picker.qflist()
    end,
    desc = "Quickfix List",
  },

  ---- Projects
  {
    "<leader>p",
    function()
      Snacks.picker.projects()
    end,
    desc = "Projects",
  },

  ------- Files
  {
    "<leader><space>",
    function()
      Snacks.picker.smart()
    end,
    desc = "Smart open",
  },
  {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "Find files",
  },
  {
    "<leader>fc",
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath "config" }
    end,
    desc = "Config files",
  },
  {
    "<leader>fr",
    function()
      Snacks.picker.recent()
    end,
    desc = "Recent",
  },
  {
    "<leader>fn",
    function()
      Snacks.rename.rename_file()
    end,
    desc = "Rename current file",
  },

  ---- Grep
  {
    "<leader>fg",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep",
  },
  {
    "<leader>fw",
    function()
      Snacks.picker.grep_word()
    end,
    desc = "Grep word",
    mode = { "n", "x" },
  },

  ---- Git
  {
    "<leader>gg",
    function()
      Snacks.lazygit()
    end,
    desc = "Lazygit",
  },
  {
    "<leader>gr",
    function()
      Snacks.picker.git_branches { layout = "select" }
    end,
    desc = "Git branches",
  },
  {
    "<leader>gl",
    function()
      Snacks.lazygit.log()
    end,
    desc = "Git logs",
  },
  {
    "<leader>gL",
    function()
      Snacks.picker.git_log_line()
    end,
    desc = "Git log line",
  },
  {
    "<leader>gb",
    function()
      Snacks.git.blame_line()
    end,
    desc = "Git blame line",
  },
  {
    "<leader>gs",
    function()
      Snacks.picker.git_status()
    end,
    desc = "Git status",
  },
  {
    "<leader>gS",
    function()
      Snacks.picker.git_stash()
    end,
    desc = "Git stash",
  },
  {
    "<leader>gd",
    function()
      Snacks.picker.git_diff()
    end,
    desc = "Git diff (hunks)",
  },
  {
    "<leader>gf",
    function()
      Snacks.picker.git_log_file()
    end,
    desc = "Git log files",
  },
  {
    "<leader>go",
    function()
      Snacks.gitbrowse()
    end,
    desc = "Git open online",
    mode = { "n", "v" },
  },

  ---- Buffers (wip)
  {
    "<leader>sb",
    function()
      Snacks.picker.lines()
    end,
    desc = "Buffer Lines",
  },
  {
    "<leader>sB",
    function()
      Snacks.picker.grep_buffers()
    end,
    desc = "Grep Open Buffers",
  },
  {
    "<leader>bl",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Buffers",
  },
  {
    "<leader>bd",
    function()
      Snacks.bufdelete()
    end,
    desc = "Delete Buffer",
  },

  -- ╭─────────────────────────────────────────────────────────╮
  -- │ Search                                                  │
  -- ╰─────────────────────────────────────────────────────────╯
  -- {
  --   '<leader>s"',
  --   function()
  --     Snacks.picker.registers()
  --   end,
  --   desc = "Registers",
  -- },
  -- {
  --   "<leader>s/",
  --   function()
  --     Snacks.picker.search_history()
  --   end,
  --   desc = "Search History",
  -- },
  -- {
  --   "<leader>sa",
  --   function()
  --     Snacks.picker.autocmds()
  --   end,
  --   desc = "Autocmds",
  -- },
  -- {
  --   "<leader>sb",
  --   function()
  --     Snacks.picker.lines()
  --   end,
  --   desc = "Buffer Lines",
  -- },
  -- {
  --   "<leader>sC",
  --   function()
  --     Snacks.picker.commands()
  --   end,
  --   desc = "Commands",
  -- },
  -- {
  --   "<leader>sd",
  --   function()
  --     Snacks.picker.diagnostics()
  --   end,
  -- desc = "Diagnostics",
  -- },
  -- {
  -- "<leader>sD",
  -- function()
  --   Snacks.picker.diagnostics_buffer()
  -- end,
  -- desc = "Buffer Diagnostics",
  -- },
  -- {
  -- "<leader>sh",
  -- function()
  --   Snacks.picker.help()
  -- end,
  -- desc = "Help Pages",
  -- },
  -- {
  -- "<leader>sH",
  -- function()
  --   Snacks.picker.highlights()
  -- end,
  -- desc = "Highlights",
  -- },
  -- {
  --   "<leader>si",
  --   function()
  --     Snacks.picker.icons()
  --   end,
  --   desc = "Icons",
  -- },
  -- {
  --   "<leader>sj",
  --   function()
  --     Snacks.picker.jumps()
  --   end,
  --   desc = "Jumps",
  -- },
  -- {
  --   "<leader>ks",
  --   function()
  --     Snacks.picker.keymaps {
  --       layout = "vertical",
  --     }
  --   end,
  --   desc = "Keymaps",
  -- },
  -- {
  --   "<leader>sl",
  --   function()
  --     Snacks.picker.loclist()
  --   end,
  --   desc = "Location List",
  -- },
  -- {
  --   "<leader>sm",
  --   function()
  --     Snacks.picker.marks()
  --   end,
  --   desc = "Marks",
  -- },
  -- {
  --   "<leader>sM",
  --   function()
  --     Snacks.picker.man()
  --   end,
  --   desc = "Man Pages",
  -- },
  -- {
  --   "<leader>sp",
  --   function()
  --     Snacks.picker.lazy()
  --   end,
  --   desc = "Search for Plugin Spec",
  -- },

  -- -- {
  --   "<leader>sR",
  --   function()
  --     Snacks.picker.resume()
  --   end,
  --   desc = "Resume",
  -- -- },
  -- -- {
  --   "<leader>su",
  --   function()
  --     Snacks.picker.undo()
  --   end,
  --   desc = "Undo History",
  -- -- },
  -- -- {
  --   "<leader>uC",
  --   function()
  --     Snacks.picker.colorschemes()
  --   end,
  --   desc = "Colorschemes",
  -- },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ LSP                                                     │
  -- ╰─────────────────────────────────────────────────────────╯
  -- {
  --   "gd",
  --   function()
  --     Snacks.picker.lsp_definitions()
  --   end,
  --   desc = "Goto Definition",
  -- },
  -- {
  --   "gD",
  --   function()
  --     Snacks.picker.lsp_declarations()
  --   end,
  --   desc = "Goto Declaration",
  -- },
  -- {
  --   "gr",
  --   function()
  --     Snacks.picker.lsp_references()
  --   end,
  --   nowait = true,
  --   desc = "References",
  -- },
  -- {
  --   "gI",
  --   function()
  --     Snacks.picker.lsp_implementations()
  --   end,
  --   desc = "Goto Implementation",
  -- },
  -- {
  --   "gy",
  --   function()
  --     Snacks.picker.lsp_type_definitions()
  --   end,
  --   desc = "Goto T[y]pe Definition",
  -- },
  -- {
  --   "<leader>ss",
  --   function()
  --     Snacks.picker.lsp_symbols()
  --   end,
  --   desc = "LSP Symbols",
  -- },
  -- {
  --   "<leader>sS",
  --   function()
  --     Snacks.picker.lsp_workspace_symbols()
  --   end,
  --   desc = "LSP Workspace Symbols",
  -- },

  ---- Other
  {
    "\\z",
    function()
      Snacks.zen()
    end,
    desc = "Toggle 'zen mode'",
  },
  {
    "\\Z",
    function()
      Snacks.zen.zoom()
    end,
    desc = "Toggle 'zoom'",
  },

  -- {
  --   "]]",
  --   function()
  --     Snacks.words.jump(vim.v.count1)
  --   end,
  --   desc = "Next Reference",
  --   mode = { "n", "t" },
  -- },
  -- {
  --   "[[",
  --   function()
  --     Snacks.words.jump(-vim.v.count1)
  --   end,
  --   desc = "Prev Reference",
  --   mode = { "n", "t" },
  -- },
  -- }

  {
    "<leader>fu",
    function()
      require("snacks").picker.undo()
    end,
    desc = "Undo tree",
  },
  {
    "<leader>sd",
    function()
      require("snacks").picker.diagnostics()
    end,
    desc = "Diagnostics",
  },
}

return M
