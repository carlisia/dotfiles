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
    -- alias_format = "%B %-d, %Y",
    -- -- Optional, default tags to add to each new daily note created.
    -- default_tags = { "daily-notes" },
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = "+ Daily",
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
