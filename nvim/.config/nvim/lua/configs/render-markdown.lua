local M = {}

local color1_bg = "#f7ca88"
local color2_bg = "#a86c9a"
local color3_bg = "#268bd2"
local color4_bg = "#849900"
local color5_bg = "#a16946"
local color6_bg = "#656565"
local color_fg = "#323449"

vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s]], color_fg, color1_bg))
vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s]], color_fg, color2_bg))
vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s]], color_fg, color3_bg))
vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s]], color_fg, color4_bg))
vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s]], color_fg, color5_bg))
vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s]], color_fg, color6_bg))

vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))

M.opts = {
  preset = "obsidian",
  completions = { lsp = { enabled = false } }, -- no need to add the nvim-cmp source if lsp based completions is enabled here.
  code = { width = "block" },
  render_modes = true,
  indent = {
    -- Turn on / off org-indent-mode.
    enabled = false,
    -- Additional modes to render indents.
    render_modes = true,
    -- Amount of additional padding added for each heading level.
    per_level = 2,
    -- Heading levels <= this value will not be indented.
    -- Use 0 to begin indenting from the very first level.
    skip_level = 2,
    -- Do not indent heading titles, only the body.
    skip_heading = false,
    -- Prefix added when indenting, one per level.
    icon = "▎",
    -- Applied to icon.
    highlight = "RenderMarkdownIndent",
  },

  -- These are the colors for the eldritch colorscheme
  heading = {
    width = { "full", "full", "block" },
    min_width = 30,
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
