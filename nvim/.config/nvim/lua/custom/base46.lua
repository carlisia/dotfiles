local M = {}

M.overrides = {
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

  --   Cursor = { bg = "white", fg = "black2" },
  --   CursorLine = { bg = "black2" },
  --   Visual = { bg = "black2" },
  --   Comment = { italic = true },
  --
  --   -- Statusline highlights
  --   ["St_cwd"] = { bg = "statusline_bg", fg = "#ffae00" },
  --
  --   -- Diff highlights
  --   ["DiffAdd"] = { bg = "#22863a", fg = "none" },
  --   ["DiffDelete"] = { bg = "none", fg = "#b31d28" },
  --   ["DiffChange"] = { bg = "#1f2231", fg = "none" },
  --   ["DiffText"] = { bg = "#394b70", fg = "none" },
}

return M
