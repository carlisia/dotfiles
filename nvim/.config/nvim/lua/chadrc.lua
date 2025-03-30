--@type ChadrcConfig
local M = {}

local highlights = require "custom_ui.base46"
local ui = require "custom_ui.statusline"

-- Powerful Collection of 68 beautifully crafted themes, extensible and compiled to bytecode
M.base46 = {
  theme = "catppuccin",
  theme_toggle = {
    "catppuccin", -- high contrast, heavy on the red
    -- "oxocarbon", -- same as above, low red
    -- "catppuccin",
    -- "oceanic-next",
    --- for when tired:
    -- "neofusion",
    -- "nightowl",
    -- "onedark",
    ------ light themes
    -- "ayu_light",
    "default-light",
    -- "one_light",
    -- "solarized_light",
  },

  -- changed_themes = {
  --   solarized_osaka = {
  --     -- base_16 = { base08 = "#ab4642" },
  --     base_30 = {
  --       -- red = "#mycol",
  --       -- black2 = "#mycol",
  --     },
  --   },

  --   onedark = { ... },
  -- },

  hl_override = highlights.overrides,
}

-- Collection of various ui's like statusline, tabline, dashboard, cheatsheet etc
M.ui = {
  cmp = ui.cmp_ui,
  statusline = ui.statusline,
}

return M
