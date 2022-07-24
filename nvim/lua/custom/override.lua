local M = {}

M.treesitter = {
  ensure_installed = {
    "go",
    "vim",
    "json",
    "toml",
    "markdown",
    "c",
    "bash",
    "lua",
    "norg",
    "yaml",
  },
	autopairs = { enable = true },
	context_commentstring = { enable = true },
	highlight = { enable = true, use_languagetree = true },
	indent = { enable = true },
	matchup = { enable = true },
}

-- M.lsp_signature = {
-- 	doc_lines = 4,
-- 	floating_window_above_cur_line = true,
-- 	-- floating_window_off_x = 10,
-- 	-- floating_window_off_y = 10,
-- 	fix_pos = false,
-- }

M.nvimtree = {
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
        folder_arrow = false,
      },
    },
    indent_markers = { enable = true },
  },

  filters = { exclude = {} },
  view = { hide_root_folder = false, adaptive_size = false },
  open_on_tab = true,
  create_in_closed_folder = true,
}

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "alpha",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvchad_cheatsheet",
    "lsp-installer",
    "norg",
    "",
  },
  char = "▏",
  buftype_exclude = { "terminal" },
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}

M.gitsigns = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
    change = {
      hl = "GitSignsChange",
      text = "",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  }
}

return M
