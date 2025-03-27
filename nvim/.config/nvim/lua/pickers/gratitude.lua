local Snacks = Snacks
local Path = require "plenary.path"
local uv = vim.loop
local vault_main = vim.env.VAULT_MAIN or ""

local function get_modified_time(path)
  local stat = uv.fs_stat(path)
  return stat and stat.mtime and stat.mtime.sec or 0
end

-- :lua require("pickers.gratitude")()
return function()
  local files = vim.fn.globpath(vault_main, "**/*.md", true, true)
  local gratitude_logs = {}
  local longest_log = 0

  for _, path in ipairs(files) do
    local lines = {}
    local fd = io.open(path, "r")
    if fd then
      for line in fd:lines() do
        table.insert(lines, line)
      end
      fd:close()
    end

    local gratitude = nil
    for _, line in ipairs(lines) do
      local raw_match = line:match "^Gratitude:%s*(.*)"
      if raw_match then
        -- Trim whitespace from both ends
        local trimmed = raw_match:gsub("^%s+", ""):gsub("%s+$", "")
        if trimmed ~= "" and trimmed ~= ":" then
          gratitude = trimmed
          break
        end
      end
    end
    if gratitude then
      local mtime = get_modified_time(path)
      local name = Path:new(path):shorten():match "([^/]+)$"
      table.insert(gratitude_logs, {
        text = gratitude, -- required for fuzzy search
        log = gratitude,
        path = path,
        name = name,
        modified = mtime,
      })
      longest_log = math.max(longest_log, #gratitude)
    end
  end

  table.sort(gratitude_logs, function(a, b)
    return a.name > b.name
  end)

  return Snacks.picker {
    items = gratitude_logs,
    title = "🌼 Gratitude Logs",
    format = function(item)
      return {
        { item.log, "SnacksPickerLabel" },
        { " | " .. item.name, "SnacksPickerComment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd("edit " .. item.path)
    end,
  }
end
