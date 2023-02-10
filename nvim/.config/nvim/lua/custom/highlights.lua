local M = {}

---@type HLTable
M.override = {
  CursorLine = {
    bg = "black2",
  },
  Comment = {
    italic = true,
  },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

M.onedarker = {
  none = "NONE",

  cursor_bg = "#AEAFAD",

  -- black
  bg = "#1C1F26",

  gray = "#5c6370",

  red = "#e06c75",

  green = "#98C379",
  sign_add = "#587c0c",

  blue = "#61AFEF",
  hint_blue = "#4FC1FF",
  dark_blue = "#223E55",

  sign_delete = "#94151b",

  cyan_test = "#00dfff",

  search_blue = "#5e81ac",
  cyan = "#56B6C2",

  yellow = "#E5C07B",
  yellow_orange = "#D7BA7D",
  info_yellow = "#FFCC66",

  orange = "#D19A66",

  fg = "#abb2bf",
  alt_bg = "#1C1F26",
  dark = "#1C1F26",
  accent = "#BBBBBB",
  dark_gray = "#2a2f3e",
  fg_gutter = "#353d46",
  context = "#4b5263",
  popup_back = "#282c34",
  search_orange = "#613214",

  light_gray = "#abb2bf",

  light_red = "#be5046",
  purple = "#C678DD",
  magenta = "#D16D9E",

  cursor_fg = "#515052",
  sign_change = "#0c7d9d",
  error_red = "#F44747",
  warning_orange = "#ff8800",

  purple_test = "#ff007c",

  diff_add = "#303d27", -- potentially good for method names
  diff_delete = "#6e3b40",
  diff_change = "#18344c",
  diff_text = "#265478",
}

return M
