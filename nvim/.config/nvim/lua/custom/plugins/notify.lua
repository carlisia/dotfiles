local M = {}

M.notify = function()
	local present, notify = pcall(require, "notify")

	if present then
		pcall(function()
			require("telescope").load_extension("notify")
		end)

		notify.setup({
			background_colour = "#121212",
			fps = 60,
			stages = "fades",
		})
		vim.api.nvim_set_keymap("n", "<leader>p", "", { callback = notify.dismiss })
	end
end

return M
