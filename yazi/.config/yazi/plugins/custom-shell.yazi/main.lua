local state_option = ya.sync(function(state, attr)
	return state[attr]
end)

local function shell_choice(shell_val)
	-- input is in lowercase always
	local alt_name_map = {
		kornshell = "ksh",
		powershell = "pwsh",
		nushell = "nu",
	}

	local shell_map = {
		bash = { shell_val = "bash", supporter = "-ic", wait_cmd = "read", separator = ";" },
		zsh = { shell_val = "zsh", supporter = "-ic", wait_cmd = "read", separator = ";" },
		fish = { shell_val = "fish", supporter = "-c", wait_cmd = "read", separator = ";" },
		pwsh = { shell_val = "pwsh", supporter = "-Command", wait_cmd = "Read-Host", separator = ";" },
		sh = { shell_val = "sh", supporter = "-c", wait_cmd = "read", separator = ";" },
		ksh = { shell_val = "ksh", supporter = "-c", wait_cmd = "read", separator = ";" },
		csh = { shell_val = "csh", supporter = "-c", wait_cmd = "$<", separator = ";" },
		tcsh = { shell_val = "tcsh", supporter = "-c", wait_cmd = "$<", separator = ";" },
		dash = { shell_val = "dash", supporter = "-c", wait_cmd = "read", separator = ";" },
		nu = { shell_val = "nu", supporter = "-l -i -c", wait_cmd = "input", separator = "| print;" },
	}

	shell_val = alt_name_map[shell_val] or shell_val
	local shell_info = shell_map[shell_val]

	if shell_info then
		return shell_info.shell_val, shell_info.supporter, shell_info.wait_cmd, shell_info.separator
	else
		return nil, "-c", "read"
	end
end

local function manage_extra_args(job)
	-- function for dealing with --option, --option=boolean, nil
	local function tobool(arg, default)
		if type(arg) == "boolean" then
			return arg
		elseif type(arg) == "string" then
			return arg:lower() == "true"
		end
		-- Fallback in case of nil
		return default
	end

	local block = tobool(job.args.block, true)
	local orphan = tobool(job.args.orphan, false)
	local wait = tobool(job.args.wait, false)
	local interactive = tobool(job.args.confirm, false)

	return block, orphan, wait, interactive
end

local function manage_additional_title_text(block, wait)
	local txt = ""
	if block or wait then
		txt = "(" .. (block and wait and "block and wait" or block and "block" or "") .. ")"
	end
	return txt
end

local function history_add(history_path, cmd_run)
	local history_file = history_path
	local history = {}

	-- Ensure the history file exists
	local file = io.open(history_file, "a+")
	if file then
		file:close()
	end

	-- Read existing history
	for line in io.lines(history_file) do
		-- add line if it is not empty
		if line:match("%S") then
			table.insert(history, line)
		end
	end

	if cmd_run == nil then
		return history
	end

	-- Append the new command to the history if it doesn't already exist
	local command_exists = false
	for _, cmd in ipairs(history) do
		if cmd == cmd_run then
			command_exists = true
			break
		end
	end

	if not command_exists then
		file = io.open(history_file, "a")
		if file then
			file:write(cmd_run .. "\n")
			file:close()
		end
	end

	return history
end

local function history_prev(history_path)
	-- get the history commands
	local history_cmds = history_add(history_path)
	if #history_cmds < 1 then
		ya.notify({ title = "Custom-Shell", content = "History is Empty.", timeout = 3 })
		return
	end
	-- preview the commands list in fzf and return selected cmd
	for i, cmd in ipairs(history_cmds) do
		history_cmds[i] = cmd:gsub("'", "'\\''") -- Escape single quotes
	end
	local permit = ya.hide()

	local cmd = string.format('%s < "%s"', "fzf", history_path)
	local handle = io.popen(cmd, "r")

	local his_cmd = ""
	if handle then
		-- strip
		his_cmd = string.gsub(handle:read("*all") or "", "^%s*(.-)%s*$", "%1")
		handle:close()
	end

	permit:drop()
	return his_cmd
end

local function entry(_, job)
	local shell_env = os.getenv("SHELL"):match(".*/(.*)")
	local shell_value, cmd, custom_shell_cmd = "", "", ""

	local history_path, save_history = state_option("history_path"), state_option("save_history")

	if job.args[1] == "auto" or job.args[1] == "history" then
		shell_value = shell_env:lower()
	elseif job.args[1] == "custom" then
		shell_value = job.args[2]
		cmd = job.args[3]
	-- when the first param is a shell name
	elseif job.args[1] ~= "history" then
		shell_value = job.args[1]:lower()
	end

	local shell_val, supp, wait_cmd, separator = shell_choice(shell_value:lower())

	if job.args[1] == "history" then
		local his_cmd = history_prev(history_path)
		if his_cmd == nil then
			return
		end
		local value, event = ya.input({
			title = "Custom-Shell History",
			position = { "top-center", y = 3, w = 40 },
			value = his_cmd,
		})
		if event == 1 then
			-- this may lead to nested zsh -c "zsh -c 'zsh -c ...'"
			-- But that's not a problem
			cmd = value
		end
	end
	if shell_val == nil then
		ya.notify("Unsupported shell: " .. shell_value .. "Choosing Default Shell: " .. shell_env)
		shell_val, supp = shell_choice(shell_env)
	end

	local block, orphan, wait, interactive = manage_extra_args(job) --  , confirm
	local additional_title_text = manage_additional_title_text(block, wait)
	local input_title = shell_value .. " Shell " .. additional_title_text .. ": "
	local event = 1

	if job.args[1] ~= "custom" and job.args[1] ~= "history" then
		cmd, event = ya.input({
			title = input_title,
			position = { "top-center", y = 3, w = 40 },
		})
	end

	if event == 1 then
		local after_cmd = separator .. (wait and wait_cmd or "exit")
		-- for history also, this will be added.
		custom_shell_cmd = shell_val .. " " .. supp .. " " .. ya.quote(cmd .. after_cmd, true)

		ya.manager_emit("shell", {
			custom_shell_cmd,
			block = block,
			interactive = interactive,
			orphan = orphan,
		})

		if save_history then
			if job.args[1] == "history" then
				-- to avoid nested "zsh -c 'zsh -c ...'"
				history_add(history_path, cmd)
			else
				history_add(history_path, custom_shell_cmd)
			end
		end
	end
end

--- @since 25.2.7

return {
	setup = function(state, options)
		local default_history_path = (
			ya.target_family() == "windows"
			and os.getenv("APPDATA") .. "\\yazi\\config\\plugins\\custom-shell.yazi\\yazi_cmd_history"
		) or (os.getenv("HOME") .. "/.config/yazi/plugins/custom-shell.yazi/yazi_cmd_history")

		state.history_path = options.history_path or default_history_path
		if state.history_path:lower() == "default" then
			state.history_path = default_history_path
		end
		state.save_history = options.save_history and true
	end,
	entry = entry,
}
