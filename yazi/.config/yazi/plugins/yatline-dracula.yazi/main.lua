--==================--
-- Dracula Theme   --
--==================--

local dracula_palette = {
	bg = "#282a36", -- Dracula background
	bg_highlight = "#44475a", -- Dracula current line/selection
	fg = "#f8f8f2", -- Dracula foreground
	blue = "#6272a4", -- Dracula comment
	cyan = "#8be9fd", -- Dracula cyan
	green = "#50fa7b", -- Dracula green
	orange = "#ffb86c", -- Dracula orange
	pink = "#ff79c6", -- Dracula pink
	purple = "#bd93f9", -- Dracula purple
	red = "#ff5555", -- Dracula red
	yellow = "#f1fa8c", -- Dracula yellow
}

--- Gets the Dracula theme.
--- @return table theme Used in Yatline.
local function dracula_theme()
	local palette = dracula_palette

	return {
		section_separator = { open = "", close = "" },
		part_separator = { open = "", close = "" },
		inverse_separator = { open = "", close = "" },
		---#=== yatline ===#---
		style_a = {
			fg = palette.bg,
			bg_mode = {
				normal = palette.purple, -- Using purple as primary mode color
				select = palette.pink, -- Using pink for select mode
				un_set = palette.red, -- Keeping red for unset mode
			},
		},
		style_b = { bg = palette.blue, fg = palette.fg },
		style_c = { bg = palette.bg_highlight, fg = palette.fg },

		permissions_t_fg = palette.cyan, -- Using cyan for 't' permissions
		permissions_r_fg = palette.yellow, -- Using yellow for 'r' permissions
		permissions_w_fg = palette.red, -- Using red for 'w' permissions
		permissions_x_fg = palette.green, -- Using green for 'x' permissions
		permissions_s_fg = palette.fg, -- Using default fg for 's' permissions

		selected = { icon = "󰻭", fg = palette.pink }, -- Using pink for selected items
		copied = { icon = "", fg = palette.green }, -- Using green for copied items
		cut = { icon = "", fg = palette.red }, -- Using red for cut items

		total = { icon = "󰮍", fg = palette.yellow }, -- Using yellow for totals
		succ = { icon = "", fg = palette.green }, -- Using green for success
		fail = { icon = "", fg = palette.red }, -- Using red for failures
		found = { icon = "󰮕", fg = palette.cyan }, -- Using cyan for found items
		processed = { icon = "󰐍", fg = palette.orange }, -- Using orange for processed items
	}
end

return {
	setup = function()
		return dracula_theme()
	end,
}
