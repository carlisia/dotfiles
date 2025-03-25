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
  new_notes_location = "§ Inbox",
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = false, -- the markdown plugin covers this
    -- Trigger completion at 2 chars.
    -- min_chars = 2,
  },
  templates = {
    subdir = vault_main .. "/_meta/Templates",
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
