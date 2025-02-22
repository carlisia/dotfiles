Snacks = Snacks

local M = {}

M.opts = {
  bigfile = { enabled = true },
  dashboard = { enabled = true },
  explorer = { enabled = false },
  indent = { enabled = true },
  input = { enabled = true },
  picker = {
    enabled = false,
    -- focus = "list",
    -- In case you want to make sure that the score manipulation above works
    -- or if you want to check the score of each file
    debug = {
      scores = true, -- show scores in the list
    },
    -- I like the "ivy" layout, so I set it as the default globaly, you can
    -- still override it in different keymaps
    layout = {
      preset = "ivy",
      -- When reaching the bottom of the results in the picker, I don't want
      -- it to cycle and go back to the top
      cycle = false,
    },
    layouts = {
      -- I wanted to modify the ivy layout height and preview pane width,
      -- this is the only way I was able to do it
      -- NOTE: I don't think this is the right way as I'm declaring all the
      -- other values below, if you know a better way, let me know
      --
      -- Then call this layout in the keymaps above
      -- got example from here
      -- https://github.com/folke/snacks.nvim/discussions/468
      ivy = {
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.5,
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
      -- I wanted to modify the layout width
      --
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
    matcher = {
      frecency = true,
    },
    win = {
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          -- I'm used to scrolling like this in LazyGit
          ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
          ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
        },
      },
    },
  },
  notifier = {
    enabled = true,
    top_down = false, -- place notifications from top to bottom
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = true },

  git = { enabled = true },
  gitbrowse = { enabled = true },
}

M.keys = {

  {
    "<leader>/",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep",
  },
  {
    "<leader>:",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  },
  {
    "<leader>n",
    function()
      Snacks.picker.notifications()
    end,
    desc = "Notification History",
  },
  -- {
  --   "<leader>e",
  --   function()
  --     Snacks.explorer()
  --   end,
  --   desc = "File Explorer",
  -- },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ Buffers                                            |
  -- ╰─────────────────────────────────────────────────────────╯
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
  -- │ Fubd Files                                              │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "<leader><space>",
    function()
      Snacks.picker.smart()
    end,
    desc = "Smart Find Files",
  },
  {
    "<leader>fc",
    function()
      Snacks.picker.files { cwd = vim.fn.stdpath "config" }
    end,
    desc = "Find Config File",
  },
  {
    "<leader>ff",
    function()
      Snacks.picker.files {
        finder = "files",
        format = "file",
        show_empty = true,
        supports_live = true,
        -- In case you want to override the layout for this keymap
        -- layout = "vscode",
      }
    end,
    desc = "Find Files",
  },
  {
    "<leader>fg",
    function()
      Snacks.picker.git_files()
    end,
    desc = "Find Git Files",
  },
  {
    "<leader>fp",
    function()
      Snacks.picker.projects()
    end,
    desc = "Projects",
  },
  {
    "<leader>fr",
    function()
      Snacks.picker.recent()
    end,
    desc = "Recent",
  },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ Git                                                     │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "<leader>gg",
    function()
      Snacks.lazygit()
    end,
    desc = "Lazygit",
  },
  {
    "<leader>gB",
    function()
      Snacks.git.blame_line()
    end,
    desc = "Git Blame Line",
  },

  {
    "<leader>gx",
    function()
      Snacks.gitbrowse()
    end,
    desc = "Git Browse",
    mode = { "n", "v" },
  },
  {
    "<leader>gt",
    function()
      Snacks.picker.git_branches {
        layout = "select",
      }
    end,
    desc = "Git Branches",
  },
  {
    "<leader>gl",
    function()
      Snacks.picker.git_log {
        finder = "git_log",
        format = "git_log",
        preview = "git_show",
        confirm = "git_checkout",
        layout = "vertical", -- Open git log in vertical view
      }
    end,
    desc = "Git Log",
  },
  {
    "<leader>gL",
    function()
      Snacks.picker.git_log_line()
    end,
    desc = "Git Log Line",
  },
  {
    "<leader>gs",
    function()
      Snacks.picker.git_status()
    end,
    desc = "Git Status",
  },
  {
    "<leader>gS",
    function()
      Snacks.picker.git_stash()
    end,
    desc = "Git Stash",
  },
  {
    "<leader>gd",
    function()
      Snacks.picker.git_diff()
    end,
    desc = "Git Diff (Hunks)",
  },
  {
    "<leader>gf",
    function()
      Snacks.picker.git_log_file()
    end,
    desc = "Git Log File",
  },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ Grep                                                    │
  -- ╰─────────────────────────────────────────────────────────╯
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
    "<leader>sg",
    function()
      Snacks.picker.grep()
    end,
    desc = "Grep",
  },
  {
    "<leader>sw",
    function()
      Snacks.picker.grep_word()
    end,
    desc = "Visual selection or word",
    mode = { "n", "x" },
  },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ Search                                                  │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    '<leader>s"',
    function()
      Snacks.picker.registers()
    end,
    desc = "Registers",
  },
  {
    "<leader>s/",
    function()
      Snacks.picker.search_history()
    end,
    desc = "Search History",
  },
  {
    "<leader>sa",
    function()
      Snacks.picker.autocmds()
    end,
    desc = "Autocmds",
  },
  {
    "<leader>sb",
    function()
      Snacks.picker.lines()
    end,
    desc = "Buffer Lines",
  },
  {
    "<leader>sc",
    function()
      Snacks.picker.command_history()
    end,
    desc = "Command History",
  },
  {
    "<leader>sC",
    function()
      Snacks.picker.commands()
    end,
    desc = "Commands",
  },
  {
    "<leader>sd",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "Diagnostics",
  },
  {
    "<leader>sD",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "Buffer Diagnostics",
  },
  {
    "<leader>sh",
    function()
      Snacks.picker.help()
    end,
    desc = "Help Pages",
  },
  {
    "<leader>sH",
    function()
      Snacks.picker.highlights()
    end,
    desc = "Highlights",
  },
  {
    "<leader>si",
    function()
      Snacks.picker.icons()
    end,
    desc = "Icons",
  },
  {
    "<leader>sj",
    function()
      Snacks.picker.jumps()
    end,
    desc = "Jumps",
  },
  {
    "<leader>sk",
    function()
      Snacks.picker.keymaps {
        layout = "vertical",
      }
    end,
    desc = "Keymaps",
  },
  {
    "<leader>sl",
    function()
      Snacks.picker.loclist()
    end,
    desc = "Location List",
  },
  {
    "<leader>sm",
    function()
      Snacks.picker.marks()
    end,
    desc = "Marks",
  },
  {
    "<leader>sM",
    function()
      Snacks.picker.man()
    end,
    desc = "Man Pages",
  },
  {
    "<leader>sp",
    function()
      Snacks.picker.lazy()
    end,
    desc = "Search for Plugin Spec",
  },
  {
    "<leader>sq",
    function()
      Snacks.picker.qflist()
    end,
    desc = "Quickfix List",
  },
  {
    "<leader>sR",
    function()
      Snacks.picker.resume()
    end,
    desc = "Resume",
  },
  {
    "<leader>su",
    function()
      Snacks.picker.undo()
    end,
    desc = "Undo History",
  },
  {
    "<leader>uC",
    function()
      Snacks.picker.colorschemes()
    end,
    desc = "Colorschemes",
  },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ LSP                                                     │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "gd",
    function()
      Snacks.picker.lsp_definitions()
    end,
    desc = "Goto Definition",
  },
  {
    "gD",
    function()
      Snacks.picker.lsp_declarations()
    end,
    desc = "Goto Declaration",
  },
  {
    "gr",
    function()
      Snacks.picker.lsp_references()
    end,
    nowait = true,
    desc = "References",
  },
  {
    "gI",
    function()
      Snacks.picker.lsp_implementations()
    end,
    desc = "Goto Implementation",
  },
  {
    "gy",
    function()
      Snacks.picker.lsp_type_definitions()
    end,
    desc = "Goto T[y]pe Definition",
  },
  {
    "<leader>ss",
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = "LSP Symbols",
  },
  {
    "<leader>sS",
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = "LSP Workspace Symbols",
  },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │ Other                                                   │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    "<leader>z",
    function()
      Snacks.zen()
    end,
    desc = "Toggle Zen Mode",
  },
  {
    "<leader>Z",
    function()
      Snacks.zen.zoom()
    end,
    desc = "Toggle Zoom",
  },
  {
    "<leader>.",
    function()
      Snacks.scratch()
    end,
    desc = "Toggle Scratch Buffer",
  },
  {
    "<leader>S",
    function()
      Snacks.scratch.select()
    end,
    desc = "Select Scratch Buffer",
  },
  {
    "<leader>n",
    function()
      Snacks.notifier.show_history()
    end,
    desc = "Notification History",
  },
  {
    "<leader>cR",
    function()
      Snacks.rename.rename_file()
    end,
    desc = "Rename File",
  },
  {
    "<leader>un",
    function()
      Snacks.notifier.hide()
    end,
    desc = "Dismiss All Notifications",
  },
  {
    "]]",
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    desc = "Next Reference",
    mode = { "n", "t" },
  },
  {
    "[[",
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    desc = "Prev Reference",
    mode = { "n", "t" },
  },
}

return M
