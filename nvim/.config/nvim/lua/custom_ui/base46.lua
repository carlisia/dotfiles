local M = {}

-- cmd = { "Huefy", "Shades" }
-- Note: the highlighting depends on the value of 'background'
M.overrides = {
  IncSearch = { fg = "#c94c16", bg = "#fff7a2", standout = true },
  Search = { fg = "#86c1b9", bg = "#570f0e", standout = true },
  DiagnosticVirtualTextWarn = { bg = "one_bg", fg = "#a48cf2", standout = false },

  -- DiffDelete = { fg = "#c94c16", bg = "#fff7a2" },
  -- gitcommitOverflowxxx = { fg = "#c94c16", bg = "#fff7a2" },
  -- gitcommitUnmergedTypexxx = { fg = "#c94c16", bg = "#fff7a2" },
  -- gitcommitDiscardedTypexxx = { fg = "#c94c16", bg = "#fff7a2" },
  -- gitcommitOverflowxxx = { fg = "#c94c16", bg = "#fff7a2" },

  -- TelescopeResultsDiffDelete = { fg = "#c94c16", bg = "#fff7a2" },
  -- DiffModified = { fg = "#c94c16", bg = "#fff7a2" },
  -- DiffChange = { fg = "#c94c16", bg = "#fff7a2" },
  -- gitcommitDiscardedFilexxx = { fg = "#c94c16", bg = "#fff7a2" },
  -- gitcommitUnmergedFilexxx = { fg = "#c94c16", bg = "#fff7a2" },

  -- statusline
  St_NormalMode = { bg = "#66ff00" },
  St_NormalModeSep = { fg = "#FF160C" },
  St_InsertMode = { bg = "#FF160C" },
  St_InsertModeSep = { fg = "#FFE900" },
  St_VisualMode = { bg = "#FFE900" },
  St_VisualModeSep = { fg = "#66ff00" },
  St_TerminalMode = { bg = "#E27D00" },
  St_TerminalModeSep = { fg = "#FF1CF3" },
  St_NTerminalMode = { bg = "#E27D00" },
  St_NTerminalModeSep = { fg = "#FF1CF3" },
}

-- base08 = "#268bd2", -- deleted
-- -- base08 = "#ab4642",
--   base06 = "#eee8d5",
--   base07 = "#fdf6e3",
--   base08 = "#268bd2",
--   base09 = "#519ABA",
--   base0A = "#b28500",
--   -- base0B = "#29a298", -- added
--   base0C = "#c94c16",
--   base0D = "#268bd2",
--   base0E = "#849900",
--   base0F = "#c94c16",

return M
