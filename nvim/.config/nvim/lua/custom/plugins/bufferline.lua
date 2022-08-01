local colors = require("base46").get_theme_tb "base_30"

local groups = {
  BufferLineBackground = { fg = colors.light_grey, bg = colors.black2 },

  BufferlineIndicatorVisible = { fg = colors.black2, bg = colors.black2 },

  -- buffers
  BufferLineBufferSelected = { fg = colors.white, bg = colors.black },

  BufferLineBufferVisible = { fg = colors.light_grey, bg = colors.black2 },

  -- for diagnostics = "nvim_lsp"
  BufferLineError = { fg = colors.light_grey, bg = colors.black2 },
  BufferLineErrorDiagnostic = { fg = colors.light_grey, bg = colors.black2 },

  -- close buttons
  BufferLineCloseButton = { fg = colors.light_grey, bg = colors.black2 },
  BufferLineCloseButtonVisible = { fg = colors.light_grey, bg = colors.black2 },
  BufferLineCloseButtonSelected = { fg = colors.red, bg = colors.black },
  BufferLineFill = { fg = colors.grey_fg, bg = colors.black2 },
  BufferlineIndicatorSelected = { fg = colors.black, bg = colors.black },

  -- modified
  BufferLineModified = { fg = colors.red, bg = colors.black2 },
  BufferLineModifiedVisible = { fg = colors.red, bg = colors.black2 },
  BufferLineModifiedSelected = { fg = colors.green, bg = colors.black },

  -- separators
  BufferLineSeparator = { fg = colors.black2, bg = colors.black2 },
  BufferLineSeparatorVisible = { fg = colors.black2, bg = colors.black2 },
  BufferLineSeparatorSelected = { fg = colors.black2, bg = colors.black2 },

  -- tabs
  BufferLineTab = { fg = colors.light_grey, bg = colors.one_bg3 },
  BufferLineTabSelected = { fg = colors.black2, bg = colors.nord_blue },
  BufferLineTabClose = { fg = colors.red, bg = colors.black },

  BufferLineDevIconDefaultSelected = { bg = "none" },

  BufferLineDevIconDefaultInactive = { bg = "none" },

  BufferLineDuplicate = { fg = "NONE", bg = colors.black2 },
  BufferLineDuplicateSelected = { fg = colors.red, bg = colors.black },
  BufferLineDuplicateVisible = { fg = colors.blue, bg = colors.black2 },

  -- custom area
  BufferLineRightCustomAreaText1 = { fg = colors.white },
  BufferLineRightCustomAreaText2 = { fg = colors.red },
}
for hl, col in pairs(groups) do
  vim.api.nvim_set_hl(0, hl, col)
end

local function config()
  return {
    options = {
      diagnostics = "nvim_lsp",
      offsets = { { filetype = "neo-tree", text = "File Explorer", text_align = "center" } },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = false,
      left_trunc_marker = " ",
      right_trunc_marker = " ",
      max_name_length = 20,
      max_prefix_length = 13,
      tab_size = 20,
      show_buffer_close_icons = true,
      themable = true,
    },
  }
end

require("bufferline").setup(config())
require("custom.mappings").bufferline()
