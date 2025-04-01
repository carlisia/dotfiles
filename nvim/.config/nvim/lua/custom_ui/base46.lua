local M = {}

-- cmd = { "Huefy", "Shades" }
-- Note: the highlighting depends on the value of 'background'
M.overrides = {
  IncSearch = { fg = "#c94c16", bg = "#fff7a2", standout = true },
  Search = { fg = "#86c1b9", bg = "#570f0e", standout = true },
  DiagnosticVirtualTextWarn = { bg = "one_bg", fg = "#a48cf2", standout = false },

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

  Visual = { bg = "#5a5e63" },

  TbBufOn = { fg = "#FF1CF3", bold = true },
  TbBufOnModified = { fg = "#FF160C" },
  TbBufOffModified = { fg = "#FF160C" },

  DiagnosticInfo = { fg = "#a48cf2" },
}

return M
