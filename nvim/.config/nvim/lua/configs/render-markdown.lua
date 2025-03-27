local M = {}

-- local color_sign = "#ebfafa"
-- local color1_bg = "#f265b5"
-- local color2_bg = "#37f499"
-- local color3_bg = "#04d1f9"
-- local color4_bg = "#a48cf2"
-- local color5_bg = "#f1fc79"
-- local color6_bg = "#f7c67f"
-- local color_fg = "#323449"

local color1_bg = "#f1fc79"
local color2_bg = "#f7c67f"
local color3_bg = "#37f499"
local color4_bg = "#f265b5"
local color5_bg = "#a48cf2"
local color6_bg = "#04d1f9"
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
  preset = "obsidian",
  completions = { lsp = { enabled = false } }, -- no need to add the nvim-cmp source if lsp based completions is enabled here.
  code = { width = "block" },

  indent = {
    -- Turn on / off org-indent-mode.
    enabled = true,
    -- Additional modes to render indents.
    render_modes = true,
    -- Amount of additional padding added for each heading level.
    per_level = 2,
    -- Heading levels <= this value will not be indented.
    -- Use 0 to begin indenting from the very first level.
    skip_level = 1,
    -- Do not indent heading titles, only the body.
    skip_heading = false,
    -- Prefix added when indenting, one per level.
    icon = "▎",
    -- Applied to icon.
    highlight = "RenderMarkdownIndent",
  },

  -- These are the colors for the eldritch colorscheme
  heading = {
    sign = true, -- display column status/guide signs for the headers
    -- icons = { "󰼏 ", "󰎨  ", "󰼑  ", "󰎲  ", "󰼓  ", "󰎴  " },
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
