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
  on = { ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", "Convert to note template" },
  of = { ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>", "clean up title" },
  om = {
    function()
      local full_path = vim.fn.expand "%:p" -- full path to current file
      local file_name = vim.fn.expand "%:t" -- just the file name
      local input = vim.fn.input {
        prompt = "Move this file to...  > ",
        completion = "dir", -- force directory completion
      }

      if input == nil or input == "" then
        return -- user canceled
      end

      local target_dir = vim.fn.fnamemodify(input, ":p") -- ensure absolute path
      local target_path = target_dir .. "/" .. file_name

      vim.cmd("saveas " .. vim.fn.fnameescape(target_path))
      vim.fn.delete(full_path)
      vim.cmd "bd#"
    end,
    "Move to...",
  },
}

M.images = {
  is = { helper.select_image, "Select an image to insert" },
  ip = { "<cmd>PasteImage<cr>", "Paste an image" },
  ir = { helper.rename_image_under_cursor, "Rename an image" },
  id = { helper.delete_image_under_cursor, "Delete an image" },
}

return M
