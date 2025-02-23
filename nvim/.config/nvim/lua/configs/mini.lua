local M = {}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
M.surround = {
  --   "echasnovski/mini.surround",
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

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
M.ai = {
  n_lines = 500,
}

M.comment = {
  mappings = {
    comment = "<C-/>",
    comment_line = "<C-.>",
    comment_visual = "<C-/><C-/>",
  },
}

local miniclue = require "mini.clue"
M.clue = {
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows { submode_resize = true },
    miniclue.gen_clues.z(),
  },
  triggers = {
    { mode = "n", keys = [[\]] }, -- mini.basics
    { mode = "n", keys = "[" }, -- mini.bracketed
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },
    { mode = "i", keys = "<C-x>" }, -- Built-in completion
    { mode = "n", keys = "g" }, -- `g` key
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" }, -- Marks
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' }, -- Registers
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" }, -- Window commands
    { mode = "n", keys = "z" }, -- `z` key
    { mode = "x", keys = "z" },
  },
  window = {
    delay = 100,
    config = {
      border = "double",
    },
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

return M
