local helper = require "utils.functions"

local M = {}

local vault_main = vim.env.VAULT_MAIN or ""

-- The config options 'completion.prepend_note_id', 'completion.prepend_note_path', and 'completion.use_path_only' are deprecated. Please use 'wiki_link_func' instead.
--
M.opts = {
  ui = { enable = false },
  workspaces = {
    {
      name = "Second Brain",
      path = vault_main,
    },
  },
  notes_subdir = "§ Inbox",
  new_notes_location = "notes_subdir",

  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "Flows/Daily Notes",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- -- Optional, default tags to add to each new daily note created.
    -- default_tags = { "daily-notes" },
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = "+ Daily Note",
  },

  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true, -- the markdown plugin covers this
    -- Trigger completion at 2 chars.
    min_chars = 2,
  },

  templates = {
    subdir = "/_meta/Templates",
    date_format = "%Y-%m-%d-%a",
    time_format = "%H:%M",
    substitutions = {
      ["date:dddd, MMMM DD, YYYY"] = function()
        local days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
        local months = {
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        }

        local t = os.date "*t"
        local day_name = days[t.wday]
        local month_name = months[t.month]
        local formatted = string.format("%s, %s %02d, %d", day_name, month_name, t.day, t.year)
        return formatted
      end,
    },
  },

  picker = {
    -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
    name = "snacks.pick",
    -- Optional, configure key mappings for the picker. These are the defaults.
    -- Not all pickers support all mappings.
    note_mappings = {
      -- Create a new note from your query.
      new = "<C-x>",
      -- Insert a link to the selected note.
      insert_link = "<C-l>",
    },
    tag_mappings = {
      -- Add tag(s) to current note.
      tag_note = "<C-x>",
      -- Insert a tag at the current location.
      insert_tag = "<C-l>",
    },
  },

  mappings = {},

  note_id_func = function(title)
    local obsidian = require "obsidian"

    if title ~= nil and title ~= "" then
      local filename = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() .. ".md"
      local path = obsidian.config.dir / filename

      if path:exists() then
        local lines = vim.fn.readfile(tostring(path))
        for _, line in ipairs(lines) do
          local id = line:match "^id:%s*(.+)"
          if id then
            return id
          end
        end
        return filename:gsub("%.md$", "")
      end
    end

    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local id = ""
    for _ = 1, 8 do
      local rand = math.random(#charset)
      id = id .. charset:sub(rand, rand)
    end
    return "nvm-" .. id
  end,

  note_path_func = function(spec)
    local filename = spec.title and spec.title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() or spec.id
    return (spec.dir / filename):with_suffix ".md"
  end,

  wiki_link_func = function(opts)
    if opts.id == nil then
      return string.format("[[%s]]", opts.label)
    elseif opts.label ~= opts.id then
      return string.format("[[%s|%s]]", opts.id, opts.label)
    else
      return string.format("[[%s]]", opts.id)
    end
  end,

  callbacks = {
    enter_note = function(client, note)
      helper.set_backlink_count(client, note)

      vim.defer_fn(function()
        local outline_open = false

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          if ft == "Outline" then
            outline_open = true
            break
          end
        end

        if not outline_open then
          vim.cmd "Outline!"
        end
      end, 100)
    end,
  },
}

M.exclude = {
  ".obsidian",
  ".trash",
  ".pandoc",
  ".reference-map",
  ".smart-env",
  ".DS_Store",
}

return M
