function hovered()
	local hovered = cx.active.current.hovered
	if hovered then
		return hovered
	else
		return ""
	end
end

local function setup(_, options)
	options = options or {}

	local config = {
		symlink_color = options.symlink_color or "silver",
	}

	if Yatline ~= nil then
		function Yatline.coloreds.get:symlink()
			local symlink = {}
			local linked = ""

			local h = hovered()
			if h.link_to ~= nil then
				linked = " -> " .. tostring(h.link_to)
			end

			table.insert(symlink, { linked, config.symlink_color })
			return symlink
		end
	end
end

return { setup = setup }
