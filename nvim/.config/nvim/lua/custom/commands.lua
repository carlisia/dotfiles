local command = vim.api.nvim_create_user_command

local M = {}

-- non plugin commands
function M.aki()
  command("Sudowrite", function()
    require("custom.utils").sudo_write()
  end, { desc = "Write to files using sudo" })
end

function M.spectre()
  command("FindReplace", function()
    require("spectre").open {}
  end, { desc = "Find and Replace in the current folder" })
end

return M
