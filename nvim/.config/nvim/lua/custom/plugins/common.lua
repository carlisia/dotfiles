local M = {}

function M.bufferline()
  require("custom.plugins.bufferline")
end

function M.cmp()
  require("custom.plugins.cmp_cmdline")
end

function M.colorizer()
  return {
    user_default_options = {
      names = false, -- "Name" codes like Blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Available modes: foreground, background
      mode = "background", -- Set the display mode.
    },
  }
end

function M.lspconfig()
  require("custom.plugins.lspconfig")
end

function M.lsp_signature()
  require("lsp_signature").setup({
    bind = false,
    handler_opts = {
      border = "rounded",
    },
    max_width = 80,
    max_height = 4,
    -- doc_lines = 4,
    floating_window = true,

    floating_window_above_cur_line = true,
    fix_pos = false,
    always_trigger = false,
    zindex = 40,
    timer_interval = 100,
  })
end

function M.null_ls()
  require("custom.plugins.null-ls")
end

function M.nvim_go()
  require("go").setup({
    -- notify: use nvim-notify
    notify = true,
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = "virtual_text",
    -- formatter: goimports, gofmt, gofumpt
    formatter = "gofumpt",
    -- maintain cursor position after formatting loaded buffer
    maintain_cursor_pos = true,
  })
  require("custom.autocmds").nvim_go()
end

function M.nvimtree()
  return {
    filters = { exclude = {} },
    view = { hide_root_folder = false, adaptive_size = false },
    renderer = { indent_markers = { enable = true }, icons = { show = { folder_arrow = false } } },
  }
end

function M.persisted()
  require("persisted").setup({
    autoload = true, -- automatically load the session for the cwd on Neovim startup
    allowed_dirs = { "~" },
    -- https://github.com/rmagatti/auto-session/issues/64#issuecomment-1111409078
    before_save = function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config_ = vim.api.nvim_win_get_config(win)
        if config_.relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end
      vim.cmd(":silent! NvimTreeClose")
      vim.cmd(":silent! Neotree close")
    end,
  })
end

function M.treesitter()
  return {
    ensure_installed = {
      "go",
      "json",
      "toml",
      "markdown",
      "c",
      "bash",
      "lua",
      "norg",
      "yaml",
      "vim",
    },
    -- autopairs = { enable = true },
    -- context_commentstring = { enable = true },
    highlight = { enable = true, use_languagetree = true },
    indent = { enable = true },
    matchup = { enable = true },
    tree_docs = { enable = true },
  }
end

function M.telescope()
  return {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
      file_ignore_patterns = { "node_modules/", ".git/" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    extension_list = { "fzf", "notify", "persisted", "neoclip" },
  }
end

function M.toggleterm()
  require("toggleterm").setup({
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        local height = vim.api.nvim_win_get_height(0)
        return (height < 10 and height) or (height * 0.8)
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    -- i basically wanted to disable the mapping so lets use a russian alphabet
    open_mapping = [[д]],
    direction = "horizontal",
  })
end

function M.diffview()
  local cb = require("diffview.config").diffview_callback

  require("diffview").setup({
    diff_binaries = false, -- Show diffs for binaries
    enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
    use_icons = true, -- Requires nvim-web-devicons
    icons = { -- Only applies when use_icons is true.
      folder_closed = "",
      folder_open = "",
    },
    signs = {
      fold_closed = "",
      fold_open = "",
    },
    file_panel = {
      listing_style = "tree", -- One of 'list' or 'tree'
      tree_options = { -- Only applies when listing_style is 'tree'
        flatten_dirs = true, -- Flatten dirs that only contain one single dir
        folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
      },
      win_config = { -- See ':h diffview-config-win_config'
        position = "left",
        width = 35,
      },
    },
    file_history_panel = {
      -- log_options = {
      --   max_count = 256, -- Limit the number of commits
      --   follow = false, -- Follow renames (only for single file)
      --   all = false, -- Include all refs under 'refs/' including HEAD
      --   merges = false, -- List only merge commits
      --   no_merges = false, -- List no merge commits
      --   reverse = false, -- List commits in reverse order
      -- },
      win_config = { -- See ':h diffview-config-win_config'
        position = "bottom",
        height = 16,
      },
    },
    commit_log_panel = {
      win_config = {}, -- See ':h diffview-config-win_config'
    },
    default_args = { -- Default args prepended to the arg-list for the listed commands
      DiffviewOpen = {},
      DiffviewFileHistory = {},
    },
    hooks = {}, -- See ':h diffview-config-hooks'
    key_bindings = {
      disable_defaults = false, -- Disable the default key bindings
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      view = {
        ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
        ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
        ["gf"] = cb("goto_file"), -- Open the file in a new split in previous tabpage
        ["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
        ["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
        ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
        ["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
      },
      file_panel = {
        ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
        ["<down>"] = cb("next_entry"),
        ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
        ["<up>"] = cb("prev_entry"),
        ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
        ["o"] = cb("select_entry"),
        ["<2-LeftMouse>"] = cb("select_entry"),
        ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
        ["S"] = cb("stage_all"), -- Stage all entries.
        ["U"] = cb("unstage_all"), -- Unstage all entries.
        ["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
        ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
        ["L"] = cb("open_commit_log"), -- Open the commit log panel.
        ["<tab>"] = cb("select_next_entry"),
        ["<s-tab>"] = cb("select_prev_entry"),
        ["gf"] = cb("goto_file"),
        ["<C-w><C-f>"] = cb("goto_file_split"),
        ["<C-w>gf"] = cb("goto_file_tab"),
        ["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
        ["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
        ["<leader>e"] = cb("focus_files"),
        ["<leader>b"] = cb("toggle_files"),
      },
      file_history_panel = {
        ["g!"] = cb("options"), -- Open the option panel
        ["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
        ["y"] = cb("copy_hash"), -- Copy the commit hash of the entry under the cursor
        ["L"] = cb("open_commit_log"),
        ["zR"] = cb("open_all_folds"),
        ["zM"] = cb("close_all_folds"),
        ["j"] = cb("next_entry"),
        ["<down>"] = cb("next_entry"),
        ["k"] = cb("prev_entry"),
        ["<up>"] = cb("prev_entry"),
        ["<cr>"] = cb("select_entry"),
        ["o"] = cb("select_entry"),
        ["<2-LeftMouse>"] = cb("select_entry"),
        ["<tab>"] = cb("select_next_entry"),
        ["<s-tab>"] = cb("select_prev_entry"),
        ["gf"] = cb("goto_file"),
        ["<C-w><C-f>"] = cb("goto_file_split"),
        ["<C-w>gf"] = cb("goto_file_tab"),
        ["<leader>e"] = cb("focus_files"),
        ["<leader>b"] = cb("toggle_files"),
      },
      option_panel = {
        ["<tab>"] = cb("select"),
        ["q"] = cb("close"),
      },
    },
  })
end

M.gitsigns = {
  signs = {
    add = { hl = "DiffAdd", text = "", mhl = "GitSignsAddNr" },
    change = { hl = "DiffChange", text = "", numhl = "GitSignsChangeNr" },
    delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
    topdelete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
    changedelete = { hl = "DiffChangeDelete", text = "", numhl = "GitSignsChangeNr" },
  },
}

return M