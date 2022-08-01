-- local fg = require("core.utils").fg
-- local bg = require("core.utils").bg
--[[
base00 - Default Background
base01 - Lighter Background (Used for status bars, line number and folding marks)
base02 - Selection Background
base03 - Comments, Invisibles, Line Highlighting
base04 - Dark Foreground (Used for status bars)
base05 - Default Foreground, Caret, Delimiters, Operators
base06 - Light Foreground (Not often used)
base07 - Light Background (Not often used)
base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
base0A - Classes, Markup Bold, Search Text Background
base0B - Strings, Inherited Class, Markup Code, Diff Inserted
base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
base0D - Functions, Methods, Attribute IDs, Headings
base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
--]]

--[[
The following variables are for base_30

black = usually your theme bg 
darker_black = 6% darker than black
black2 = 6% lighter than black

onebg = 10% lighter than black
oneb2 = 19% lighter than black
oneb3 = 27% lighter than black

grey = 40% lighter than black (the % here depends so choose the perfect grey!)
grey_fg = 10% lighter than grey
grey_fg2 = 20% lighter than grey
light_grey = 28% lighter than grey

baby_pink = 15% lighter than red or any babypink color you like!
line = 15% lighter than black 

nord_blue = 13% darker than blue 
sun = 8% lighter than yellow

statusline_bg = 4% lighter than black
lightbg = 13% lighter than statusline_bg
lightbg2 = 7% lighter than statusline_bg

folder_bg = blue color
]]

local M = {}

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
--
-- local c = {
-- 	none = "NONE",
-- 	bg_dark = "#1f2335",
-- 	bg = "#24283b",
-- 	bg_highlight = "#292e42",
-- 	terminal_black = "#414868",
-- 	fg = "#c0caf5",
-- 	fg_dark = "#a9b1d6",
-- 	fg_gutter = "#3b4261",
-- 	dark3 = "#545c7e",
-- 	comment = "#565f89",
-- 	dark5 = "#737aa2",
-- 	blue0 = "#3d59a1",
-- 	-- blue:
-- 	blue = "#7aa2f7",
-- 	cyan = "#7dcfff",
-- 	blue1 = "#2ac3de",
-- 	blue2 = "#0db9d7",
-- 	blue5 = "#89ddff",
-- 	blue6 = "#B4F9F8",
-- 	blue7 = "#394b70",
-- 	magenta = "#bb9af7",
-- 	magenta2 = "#ff007c",
-- 	purple = "#9d7cd8",
-- 	orange = "#ff9e64",
-- 	yellow = "#e0af68",
-- 	green = "#9ece6a",
-- 	green1 = "#73daca",
-- 	green2 = "#41a6b5",
-- 	teal = "#1abc9c",
-- 	red = "#f7768e",
-- 	red1 = "#db4b4b",
-- 	git = { change = "#6183bb", add = "#449dab", delete = "#914c54", conflict = "#bb7a61" },
-- 	gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" },
-- }
-- --
-- vim.cmd("hi Statement guifg=9d7cd8 gui=none")
--
-- fg("TSProperty", c.green1)
-- fg("TSTag", c.magenta)
-- fg("TSTagDelimiter", c.blue2)
-- fg("TSType", c.blue1)
-- fg("TSOperator", c.blue5)
-- fg("TSParameter", c.yellow)
-- fg("Label", c.cyan)
-- fg("TSKeyword", c.purple)
-- fg("TSConditional", c.magenta)
-- fg("TSInclude", c.cyan)
-- fg("TSConstructor", c.magenta)
-- bg("Normal", c.bg)
-- bg("CursorLine", c.bg_highlight)
--
--
-- return {
-- 	Pmenu = { bg = "#ffffff" },
-- 	MyHighlightGroup = onedarker,
-- 	MyHighlightGroupc = c, -- this is fake
-- }

return M
