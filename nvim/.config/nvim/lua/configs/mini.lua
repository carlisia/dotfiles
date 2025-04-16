local M = {}

local vault_main = vim.env.VAULT_MAIN or ""
vault_main = vim.fs.normalize(vault_main):gsub("/$", "")

local excluded_list = require("configs.obsidian").exclude
local excluded = {}
for _, name in ipairs(excluded_list) do
  excluded[name] = true
end

local function filter_fn(entry)
  local is_in_vault = vim.startswith(entry.path, vault_main)
  if is_in_vault and excluded[entry.name] then
    return false
  end
  return true
end

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
    basic = true, -- 'number', 'ignorecase', ...
    extra_ui = false, -- 'winblend' (sets floating win to transparent), 'cmdheight=0', ...
    win_borders = "double", -- 'default', single', 'double', ...
  },

  mappings = {
    -- Basic mappings (better 'jk', save with Ctrl+S, ...)
    basic = true,
    -- Window navigation with <C-hjkl>, resize with <C-arrow>
    windows = true,
    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = true,
  },

  autocommands = {
    -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
    basic = true,
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

    { mode = "n", keys = "<leader>b", desc = "Buffers..." },
    { mode = "n", keys = "<leader>g", desc = "Git..." },
    { mode = "n", keys = "<leader>f", desc = "Files..." },
    { mode = "n", keys = "<leader>l", desc = "LSP..." },
    { mode = "n", keys = "<leader>n", desc = "Notifications..." },
    { mode = "n", keys = "<leader>p", desc = "Proj/Todos..." },
    { mode = "n", keys = "<leader>s", desc = "Snacks..." },
    { mode = "n", keys = "<leader>w", desc = "Dashboards..." },
    { mode = "n", keys = "<leader>-", desc = "Sessions..." },

    -- These are language dependent - adding here for namespacing
    -- Go
    { mode = "n", keys = "<leader>d", desc = "-- Code debug..." },
    { mode = "n", keys = "<leader>m", desc = "-- Go mod..." },
    { mode = "n", keys = "<leader>r", desc = "-- Code run..." },
    { mode = "n", keys = "<leader>t", desc = "-- Code test..." },
    { mode = "n", keys = "<leader>u", desc = "-- Code utils..." },
    -- Images/markdown
    { mode = "n", keys = "<leader>o", desc = "-- Obsidian..." },
    { mode = "n", keys = "<leader>oa", desc = "Actions..." },
    { mode = "n", keys = "<leader>od", desc = "Dailies..." },
    { mode = "n", keys = "<leader>ol", desc = "Links..." },
    { mode = "n", keys = "<leader>ot", desc = "Templates..." },

    { mode = "n", keys = "<leader>i", desc = "-- Images..." },
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
    { mode = "n", keys = "<leader>" }, -- mini.basics
    { mode = "n", keys = "[" }, -- mini.bracketed
    { mode = "n", keys = "]" },
    { mode = "x", keys = "[" },
    { mode = "x", keys = "]" },

    -- select, swap, mov, repeat
  },
  window = {
    delay = 100,
    config = {
      border = "double",
    },
  },
}

vim.cmd [[
hi! MiniHipatternsCustDone guifg=#000000 guibg=#00CC00 gui=bold
hi! MiniHipatternsCustNote guifg=#FF4000 guibg=#FFFF00 gui=bold
]]
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
    preview = false,
    width_focus = 30,
    width_preview = 80,
  },
  mappings = {
    go_in_plus = "<Tab>",
    close = "<Esc>",
  },

  content = {
    filter = filter_fn,
  },
}

M.sessions = {
  hooks = {
    pre = {
      write = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "Outline" then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
      end,
    },
    post = {
      read = function()
        -- Wait until everything's restored before cleaning up
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            local bt = vim.api.nvim_buf_get_option(buf, "buftype")

            if name == "" and bt == "" then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end
        end)
      end,
    },
  },
}

return M
