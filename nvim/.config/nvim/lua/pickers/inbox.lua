local Snacks = Snacks -- your global alias
local Path = require("plenary.path")
local uv = vim.loop
local vault_main = vim.env.VAULT_MAIN or ""

local function get_creation_time(path)
  local stat = uv.fs_stat(path)
  return stat and stat.birthtime and stat.birthtime.sec or 0
end

-- :lua require("pickers.inbox")()
return function()
  local dir = vault_main .. "/§ Inbox"
  local files = vim.fn.globpath(dir, "**/*.md", true, true)

  local items = {}
  local longest_name = 0

  for _, path in ipairs(files) do
    local relpath = Path:new(path):make_relative(dir)

    -- Skip files in § Inbox/00 Sleeping
    if relpath:match("^00 Sleeping/") then
      goto continue
    end

    local filename = Path:new(path):shorten():match("([^/]+)$")

    -- Skip files that start with "@"
    if filename:sub(1, 1) == "@" then
      goto continue
    end

    local ctime = get_creation_time(path)
    local name = filename or path
    local label = string.format("%s | %s", name, os.date("%Y-%m-%d", ctime))

    table.insert(items, {
      text = label,
      name = name,
      path = path,
      created = ctime,
    })

    longest_name = math.max(longest_name, #name)

    ::continue::
  end

  -- Sort by creation date (newest first)
  table.sort(items, function(a, b)
    return a.created > b.created
  end)

  -- Use Snacks picker with formatted label
  return Snacks.picker({
    title = "📥 Inbox Notes Review",
    items = items,
    format = function(item)
      return {
        { ('%-' .. longest_name .. 's'):format(item.name), 'SnacksPickerLabel' },
        { " | " .. os.date("%Y-%m-%d", item.created), 'SnacksPickerComment' },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.cmd("edit " .. item.path)
    end,
  })
end
