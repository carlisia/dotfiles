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
  oae = { "<cmd>Obsidian extract note<cr>", "Extract selection to new note" },
  oar = { "<cmd>Obsidian rename<cr>", "Rename note and update backlinks" },

  -- Daily note commands
  odt = { "<cmd>Obsidian today<cr>", "Open/create today's note" },
  odd = { "<cmd>Obsidian dailies<cr>", "List daily notes" },
  odm = { "<cmd>Obsidian tomorrow<cr>", "Open/create tomorrow's note" },
  ody = { "<cmd>Obsidian yesterday<cr>", "Open/create yesterday's note" },

  -- Links
  olh = { "<cmd>Obsidian follow link hsplit<cr>", "Open link horizontal" },
  olv = { "<cmd>Obsidian follow link vsplit<cr>", "Open link vertical" },

  olb = { "<cmd>Obsidian backlinks<cr>", "Show backlinks to current note" },
  oll = { "<cmd>Obsidian links<cr>", "List links in current buffer" },
  oln = { "<cmd>Obsidian link new<cr>", "New linked note from selection" },
  ols = { "<cmd>Obsidian link<cr>", "Link visual selection to note" },

  -- Template-related
  otc = { ":Obsidian template note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", "Convert to note template" },
  oti = { "<cmd>Obsidian template<cr>", "Insert template" },
  otn = { "<cmd>Obsidian new from template<cr>", "New note from template" },

  -- Others
  of = { "<cmd>Obsidian follow link<cr>", "Open link" },
  og = { "<cmd>Obsidian tags<cr>", "Show all tags in vault" },
  on = { ":CreateOrOpenNote ", "Create or open note" },
  op = { "<cmd>MarkdownPreview<cr>", "Preview on browser" },
  os = { "<cmd>Obsidian search<cr>", "Search/create note with picker" },
  ox = { "<cmd>Obsidian toggle checkbox<cr>", "Toggle checkbox" },
}

M.images = {
  is = { helper.select_image, "Select an image to insert" },
  ip = { "<cmd>PasteImage<cr>", "Paste an image" },
  ir = { helper.rename_image_under_cursor, "Rename an image" },
  id = { helper.delete_image_under_cursor, "Delete an image" },
}

return M
