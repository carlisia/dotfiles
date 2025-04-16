local helper = require "utils.functions"

local M = {}

--- Dashboards
M.notes_dashboards = {
  wf = {
    function()
      require "pickers.fleeting_notes"()
    end,
    "🌀 Fleeting notes",
  },
  wg = {
    function()
      require "pickers.gratitude"()
    end,
    "🌼 Gratitude logs",
  },
  wi = {
    function()
      require "pickers.inbox"()
    end,
    "📥 Inbox",
  },
}

M.obsidian_workflows = {
  -- General note actions
  oae = { "<cmd>ObsidianExtractNote<cr>", "Extract selection to new note" },
  oar = { "<cmd>ObsidianRename<cr>", "Rename note and update backlinks" },

  -- Daily note commands
  odt = { "<cmd>ObsidianToday<cr>", "Open/create today's note" },
  odd = { "<cmd>ObsidianDailies<cr>", "List daily notes" },
  odm = { "<cmd>ObsidianTomorrow<cr>", "Open/create tomorrow's note" },
  ody = { "<cmd>ObsidianYesterday<cr>", "Open/create yesterday's note" },

  -- Links
  olh = { "<cmd>ObsidianFollowLink hsplit<cr>", "Open link horizontal" },
  olv = { "<cmd>ObsidianFollowLink vsplit<cr>", "Open link vertical" },

  olb = { "<cmd>ObsidianBacklinks<cr>", "Show backlinks to current note" },
  oll = { "<cmd>ObsidianLinks<cr>", "List links in current buffer" },
  oln = { "<cmd>ObsidianLinkNew<cr>", "New linked note from selection" },
  ols = { "<cmd>ObsidianLink<cr>", "Link visual selection to note" },

  -- Template-related
  otc = { ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", "Convert to note template" },
  oti = { "<cmd>ObsidianTemplate<cr>", "Insert template" },
  otn = { "<cmd>ObsidianNewFromTemplate<cr>", "New note from template" },

  -- Others
  og = { "<cmd>ObsidianTags<cr>", "Show all tags in vault" },
  on = { ":CreateOrOpenNote ", "Create or open note" },
  op = { "<cmd>MarkdownPreview<cr>", "Preview on browser" },
  os = { "<cmd>ObsidianSearch<cr>", "Search/create note with picker" },
  ox = { "<cmd>ObsidianToggleCheckbox<cr>", "Toggle checkbox" },
}

M.images = {
  is = { helper.select_image, "Select an image to insert" },
  ip = { "<cmd>PasteImage<cr>", "Paste an image" },
  ir = { helper.rename_image_under_cursor, "Rename an image" },
  id = { helper.delete_image_under_cursor, "Delete an image" },
}

return M
