local M = {}

-- local color_sign = "#ebfafa"
local color1_bg = "#f265b5"
local color2_bg = "#37f499"
local color3_bg = "#04d1f9"
local color4_bg = "#a48cf2"
local color5_bg = "#f1fc79"
local color6_bg = "#f7c67f"
local color_fg = "#323449"

vim.cmd(
  string.format(
    [[
  hi! Headline1Bg guifg=%s guibg=%s
  hi! Headline2Bg guifg=%s guibg=%s
  hi! Headline3Bg guifg=%s guibg=%s
  hi! Headline4Bg guifg=%s guibg=%s
  hi! Headline5Bg guifg=%s guibg=%s
  hi! Headline6Bg guifg=%s guibg=%s
  hi! RenderMarkdownCodeInline guifg=%s guibg=%s
]],
    color1_bg,
    color_fg,
    color2_bg,
    color_fg,
    color3_bg,
    color_fg,
    color4_bg,
    color_fg,
    color5_bg,
    color_fg,
    color6_bg,
    color_fg,
    color6_bg,
    color_fg
  )
)

vim.cmd(string.format(
  [[
  hi! Headline1Fg cterm=bold gui=bold guifg=%s
  hi! Headline2Fg cterm=bold gui=bold guifg=%s
  hi! Headline3Fg cterm=bold gui=bold guifg=%s
  hi! Headline4Fg cterm=bold gui=bold guifg=%s
  hi! Headline5Fg cterm=bold gui=bold guifg=%s
  hi! Headline6Fg cterm=bold gui=bold guifg=%s
]],
  color1_bg,
  color2_bg,
  color3_bg,
  color4_bg,
  color5_bg,
  color6_bg
))

M.opts = {
  completions = { lsp = { enabled = true } },
  code = { width = "block" },

  -- These are the colors for the eldritch colorscheme
  heading = {
    sign = true,
    icons = { "󰼏 ", "󰎨  ", "󰼑  ", "󰎲  ", "󰼓  ", "󰎴  " },
    backgrounds = {
      "Headline1Bg",
      "Headline2Bg",
      "Headline3Bg",
      "Headline4Bg",
      "Headline5Bg",
      "Headline6Bg",
    },
    foregrounds = {
      "Headline1Fg",
      "Headline2Fg",
      "Headline3Fg",
      "Headline4Fg",
      "Headline5Fg",
      "Headline6Fg",
    },
  },
}

return M
