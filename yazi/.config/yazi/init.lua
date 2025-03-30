-- yati.manager
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})

-- Plugins
-- require("zoxide"):setup({
-- 	update_db = true,
-- })

-- require("session"):setup({
-- 	sync_yanked = true,
-- })

require("git"):setup()
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- yatline and add-ons
local tokyo_night_theme = require("yatline-tokyo-night"):setup("night")
local dracula_theme = require("yatline-dracula"):setup()
local theme_in_use = dracula_theme

require("yatline"):setup({
	-- theme = tokyo_night_theme,
	theme = theme_in_use,

	show_background = false,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {
				{ type = "coloreds", custom = false, name = "symlink" },
			},
			section_c = {
				{ type = "coloreds", custom = false, name = "githead" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_path" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})

-- yatline add-ons (must come AFTER yatline)
require("yatline-githead"):setup({
	theme = tokyo_night_theme,
})
require("yatline-symlink"):setup()
