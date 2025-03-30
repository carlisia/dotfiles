--- @since 25.2.26

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

return {
	entry = function()
		ya.mgr_emit("escape", { visual = true })

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify { title = "Chmod", content = "No file selected", level = "warn", timeout = 5 }
		end

		local value, event = ya.input {
			title = "Chmod:",
			position = { "top-center", y = 3, w = 40 },
		}
		if event ~= 1 then
			return
		end

		local status, err = Command("chmod"):arg(value):args(urls):spawn():wait()
		if not status or not status.success then
			ya.notify {
				title = "Chmod",
				content = string.format("Chmod on selected files failed, error: %s", status and status.code or err),
				level = "error",
				timeout = 5,
			}
		end
	end,
}
