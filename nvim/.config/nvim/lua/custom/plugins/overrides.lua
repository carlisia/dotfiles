local M = {}

M.mason = {
  ensure_installed = {
    "lua-language-server",
    "stylua",
    "gopls",
    "bashls",
    "marksman",
    "yamlls",
    "jsonls",
    "dockerls",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.treesitter = {
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
  autopairs = { enable = true },
  context_commentstring = { enable = true },
  highlight = { enable = true, use_languagetree = true },
  indent = { enable = true },
  matchup = { enable = true },
  tree_docs = { enable = true },
}

M.telescope = {
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
  extension_list = { "fzf", "notify", "persisted", "neoclip", "octo" },
}

M.colorizer = {
  filetypes = { "*", "!cmp_menu" },
  user_default_options = {
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- #0xAARRGGBA hex codes
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    -- Available modes: foreground, background
    mode = "background", -- Set the display mode.
    tailwind = false,
    sass = { enable = true },
  },
  buftypes = { "*", "!terminal", "!prompt", "!popup" },
}

function M.bufferline()
  require("custom.plugins.bufferline")
end

function M.lspconfig()
  require("custom.plugins.lspconfig")
end

function M.cmp()
  local cmp = require("cmp")
  cmp.setup.git = {
    sources = {
      { name = "git" },
    },
  }
  require("custom.plugins.cmp_cmdline")
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

-- function M.nvim_go()
--   require("go").setup({
--     -- notify: use nvim-notify
--     notify = true,
--     -- lint_prompt_style: qf (quickfix), vt (virtual text)
--     lint_prompt_style = "virtual_text",
--     -- formatter: goimports, gofmt, gofumpt
--     formatter = "gofumpt",
--     -- maintain cursor position after formatting loaded buffer
--     maintain_cursor_pos = true,
--   })
--   require("custom.autocmds").nvim_go()
-- end

function M.go_nvim()
  require("go").setup({
    go = "go", -- go command, can be go[default] or go1.18beta1
    goimport = "gopls", -- goimport command, can be gopls[default] or goimport
    fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
    gofmt = "gofumpt", -- gofmt cmd,
    max_line_len = 120, -- max line length in goline format
    tag_transform = false, -- tag_transfer  check gomodifytags for details
    test_template = "", -- default to testify if not set; g:go_nvim_tests_template  check gotests for details
    test_template_dir = "", -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
    comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
    icons = { breakpoint = "🧘", currentpos = "🏃" },
    verbose = true, -- output loginf in messages
    lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
    -- false: do nothing
    -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
    --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
    lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
    lsp_on_attach = nil,
    -- function(client, bufnr)
    --   require("custom.plugins.lsputils").custom_lsp_attach(client, bufnr)
    -- end, -- nil: use on_attach function defined in go/lsp.lua,
    --      when lsp_cfg is true
    -- if lsp_on_attach is a function: use this function as on_attach function for gopls
    lsp_codelens = true, -- set to false to disable codelens, true by default
    lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
    lsp_diag_hdlr = true, -- hook lsp diag handler
    lsp_diag_virtual_text = { space = 0, prefix = "" }, -- virtual text setup
    lsp_diag_signs = true,
    lsp_diag_update_in_insert = true,
    lsp_document_formatting = false,
    -- set to true: use gopls to format
    -- false if you want to use other formatter tool(e.g. efm, nulls)
    gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
    gopls_remote_auto = true, -- add -remote=auto to gopls
    dap_debug = false, -- set to false to disable dap
    dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
    -- false: do not use keymap in go/dap.lua.  you must define your own.
    dap_debug_gui = true, -- set to true to enable dap gui, highly recommended
    dap_debug_vt = true, -- set to true to enable dap virtual text
    build_tags = "", -- set default build tags
    textobjects = true, -- enable default text jobects through treesittter-text-objects
    test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
    run_in_floaterm = true, -- set to true to run in float window.
    -- float term recommended if you use richgo/ginkgo with terminal color
  })
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
      vim.cmd(":silent! Neotree close")
    end,
  })
end

function M.toggleterm()
  return {
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
  }
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

M.aerial = function()
  require("aerial").setup({
    close_behavior = "auto",
    default_direction = "prefer_right",
    highlight_on_hover = true,
  })
end

M.blankline = {
  indentLine_enabled = 1,
  filetype_exclude = {
    "help",
    "terminal",
    "alpha",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "",
  },
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = true,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = true,
}

return M
