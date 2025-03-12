local M = {}

M.ai = {
  mappings = {
    -- Main textobject prefixes
    around = "a",
    inside = "i",

    -- Next/last variants
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",

    -- Move cursor to corresponding edge of `a` textobject
    goto_left = "g[",
    goto_right = "g]",
  },
}

M.basics = {
  options = {
    basic = true, -- 'number', 'ignorecase', ... (conform takes precedence on formating on save)
    extra_ui = false, -- 'winblend' (sets floating win to transparent), 'cmdheight=0', ...
    win_borders = "double", -- 'default', single', 'double', ...
  },

  mappings = {
    -- Window navigation with <C-hjkl>, resize with <C-arrow>
    windows = true,
    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = true,
  },

  autocommands = {
    -- Set 'relativenumber' only in linewise and blockwise Visual mode
    relnum_in_visual_mode = true,
  },
}

M.comment = {
  options = {
    ignore_blank_line = true,
  },
  mappings = {
    comment = "-",
    comment_line = "-",
    comment_visual = "-",
    textobject = "-",
  },
}

local miniclue = require "mini.clue"
M.clue = {
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows {
      submode_move = true,
      submode_navigate = true,
      submode_resize = true,
    },
    miniclue.gen_clues.z(),

    -- Submode for iterating buffers and windows with mini.bracketed:
    { mode = "n", keys = "]b", postkeys = "]" },
    { mode = "n", keys = "]w", postkeys = "]" },
    { mode = "n", keys = "[b", postkeys = "[" },
    { mode = "n", keys = "[w", postkeys = "[" },
  },
  triggers = {
    -- Built-in completion
    { mode = "i", keys = "<C-x>" }, -- INSERT ONLY

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key'
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },

    -- Extra
    { mode = "n", keys = [[\]] }, -- mini.basics
    { mode = "n", keys = "[" }, -- mini.bracketed
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },

    { mode = "n", keys = "<leader>" }, -- mini.basics

    -- `c` key - adding/looking for comments (todo, fix, etc)
    { mode = "n", keys = "<leader>c" },
    { mode = "x", keys = "<leader>c" },

    -- `b` buffer
    { mode = "n", keys = "<leader>b" },

    -- select, swap, mov, repeat
  },
  window = {
    delay = 100,
    config = {
      border = "double",
    },
  },
}

M.hipatterns = {
  highlighters = {
    done = { pattern = "%f[%w]()DONE()%f[%W]", group = "MiniHipatternsCustDone" },
    fixing = { pattern = "%f[%w]()fixing()%f[%W]", group = "MiniHipatternsFixme" },
    hacking = { pattern = "%f[%w]()hacking()%f[%W]", group = "MiniHipatternsHack" },
    noting = { pattern = "%f[%w]()noting()%f[%W]", group = "MiniHipatternsCustNote" },
  },
}

M.files = {
  options = {
    -- Whether to delete permanently or move into module-specific trash
    -- To get this dir run :echo stdpath('data')
    -- ~/.local/share/neobean/mini.files/trash
    permanent_delete = false,
  },
  windows = {
    preview = true,
    width_focus = 30,
    width_preview = 80,
  },
  mappings = {
    go_in_plus = "<Tab>",
  },
}

M.move = {
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = "H",
    right = "L",
    down = "J",
    up = "K",

    -- Move current line in Normal mode
    line_left = "H",
    line_right = "L",
    line_down = "J",
    line_up = "K",
  },
}

M.sessions = {
  directory = vim.fn.stdpath "config" .. "/sessions",
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
--
--   mappings = {
--   add = 'sa', -- Add surrounding in Normal and Visual modes
--   delete = 'sd', -- Delete surrounding
--   find = 'sf', -- Find surrounding (to the right)
--   find_left = 'sF', -- Find surrounding (to the left)
--   highlight = 'sh', -- Highlight surrounding
--   replace = 'sr', -- Replace surrounding
--   update_n_lines = 'sn', -- Update `n_lines`

--   suffix_last = 'l', -- Suffix to search with "prev" method
--   suffix_next = 'n', -- Suffix to search with "next" method
-- },
M.surround = {
  recommended = true,
  --   keys = function(_, keys)
  --     -- Populate the keys based on the user's options
  --     local opts = LazyVim.opts "mini.surround"
  --     local mappings = {
  --       { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
  --       { opts.mappings.delete, desc = "Delete Surrounding" },
  --       { opts.mappings.find, desc = "Find Right Surrounding" },
  --       { opts.mappings.find_left, desc = "Find Left Surrounding" },
  --       { opts.mappings.highlight, desc = "Highlight Surrounding" },
  --       { opts.mappings.replace, desc = "Replace Surrounding" },
  --       { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
  --     }
  --     mappings = vim.tbl_filter(function(m)
  --       return m[1] and #m[1] > 0
  --     end, mappings)
  --     return vim.list_extend(mappings, keys)
  --   end,
  --   opts = {
  --     mappings = {
  --       add = "gsa", -- Add surrounding in Normal and Visual modes
  --       delete = "gsd", -- Delete surrounding
  --       find = "gsf", -- Find surrounding (to the right)
  --       find_left = "gsF", -- Find surrounding (to the left)
  --       highlight = "gsh", -- Highlight surrounding
  --       replace = "gsr", -- Replace surrounding
  --       update_n_lines = "gsn", -- Update `n_lines`
  --     },
  --   },
}

return M
