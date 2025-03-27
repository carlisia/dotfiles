local Snacks = Snacks
local Path = require "plenary.path"
local uv = vim.loop
local vault_main = vim.env.VAULT_MAIN or ""

-- Read file content
local function read_file(path)
  local fd = io.open(path, "r")
  if not fd then
    return ""
  end
  local content = fd:read "*a"
  fd:close()
  return content or ""
end

local function get_modified_time(path)
  local stat = uv.fs_stat(path)
  return stat and stat.mtime and stat.mtime.sec or 0
end

-- :lua require("pickers.fleeting")()
return function()
  local files = vim.fn.globpath(vault_main, "**/*.md", true, true)
  local fleeting_notes = {}
  local longest_note = 0

  for _, path in ipairs(files) do
    local content = read_file(path)
    for line in content:gmatch "[^\r\n]+" do
      local match = line:match "%*%*Fleeting%*%*::%s*(.+)"
      if match then
        local mtime = get_modified_time(path)
        local name = Path:new(path):shorten():match "([^/]+)$"
        table.insert(fleeting_notes, {
          text = match,
          note = match,
          path = path,
          name = name,
          modified = mtime,
        })
        longest_note = math.max(longest_note, #match)
      end
    end
  end

  -- Sort descending by file modified time
  table.sort(fleeting_notes, function(a, b)
    return a.modified > b.modified
  end)

  -- Take top 10 only
  local items = vim.list_slice(fleeting_notes, 1, 10)

  return Snacks.picker {
    title = "🌀 Recent Fleeting Notes",
    items = items,
    format = function(item)
      return {
        { item.note, "SnacksPickerLabel" },
        { " | " .. item.name, "SnacksPickerComment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd("edit " .. item.path)
    end,
  }
end
