local M = {}

M.obsidian_workflow = {
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

  --- Dashboards
  df = {
    function()
      require "pickers.fleeting_notes"()
    end,
    "🌀 Fleeting notes",
  },
  dg = {
    function()
      require "pickers.gratitude"()
    end,
    "🌼 Gratitude logs",
  },
  di = {
    function()
      require "pickers.inbox"()
    end,
    "📥 Inbox",
  },
}
-- DiffRemoved   xxx guifg=#db302d guibg=#16151b

return M
