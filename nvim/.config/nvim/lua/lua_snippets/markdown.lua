local ls = require "luasnip"
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- ⏰ Timestamp snippet
  s(
    "log time",
    fmt("- ⏰ **{}:{}:{} {}:** {}", {
      f(function()
        local hour = tonumber(os.date "%H" or "0")
        return string.format("%02d", (hour % 12 == 0) and 12 or hour % 12)
      end),
      f(function()
        return tostring(os.date "%M")
      end),
      f(function()
        return tostring(os.date "%S")
      end),
      f(function()
        return tostring(os.date "%p")
      end),
      i(1),
    })
  ),

  -- ⏮️⏭️ Fleeting note snippet
  s(
    "flt",
    fmt("- ⏮️⏭️ *{}:{}:{} {}:* **Fleeting**:: {}", {
      f(function()
        local hour = tonumber(os.date "%H" or "0")
        return string.format("%02d", (hour % 12 == 0) and 12 or hour % 12)
      end),
      f(function()
        return tostring(os.date "%M")
      end),
      f(function()
        return tostring(os.date "%S")
      end),
      f(function()
        return tostring(os.date "%p")
      end),
      i(1),
    })
  ),
}
