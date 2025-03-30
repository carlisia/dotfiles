--- @since 25.3.2

-- Plugin to make some Yazi commands smarter
-- Written in Lua 5.4

-- Type aliases

-- The type for the arguments
---@alias Arguments table<string|number, string|number|boolean>

-- The type for the function to handle a command
--
-- Description of the function parameters:
--	args: The arguments to pass to the command
--	config: The configuration object
---@alias CommandFunction fun(
---	args: Arguments,
---	config: Configuration): nil

-- The type of the command table
---@alias CommandTable table<SupportedCommands, CommandFunction>

-- The type for the extractor list items command
---@alias ExtractorListItemsCommand fun(
---	self: Extractor,
---): output: CommandOutput|nil, error: Error|nil

-- The type for the extractor get items function
---@alias ExtractorGetItems fun(
---	self: Extractor,
---): files: string[], directories: string[], error: string|nil

-- The type for the extractor extract function.
---@alias ExtractorExtract fun(
---	self: Extractor,
---	has_only_one_file: boolean|nil,
---): ExtractionResult

-- The type for the extractor function
---@alias ExtractorCommand fun(): output: CommandOutput|nil, error: Error|nil

-- Custom types

-- The type of the user configuration table
-- The user configuration for the plugin
---@class (exact) UserConfiguration
---@field prompt boolean Whether or not to prompt the user
---@field default_item_group_for_prompt ItemGroup The default prompt item group
---@field smart_enter boolean Whether to use smart enter
---@field smart_paste boolean Whether to use smart paste
---@field smart_tab_create boolean Whether to use smart tab create
---@field smart_tab_switch boolean Whether to use smart tab switch
---@field confirm_on_quit boolean Whether to show a confirmation when quitting
---@field open_file_after_creation boolean Whether to open after creation
---@field enter_directory_after_creation boolean Whether to enter after creation
---@field use_default_create_behaviour boolean Use Yazi's create behaviour?
---@field enter_archives boolean Whether to enter archives
---@field extract_retries number How many times to retry extracting
---@field recursively_extract_archives boolean Extract inner archives or not
---@field preserve_file_permissions boolean Whether to preserve file permissions
---@field must_have_hovered_item boolean Whether to stop when no item is hovered
---@field skip_single_subdirectory_on_enter boolean Skip single subdir on enter
---@field skip_single_subdirectory_on_leave boolean Skip single subdir on leave
---@field smooth_scrolling boolean Whether to smoothly scroll or not
---@field scroll_delay number The scroll delay in seconds for smooth scrolling
---@field wraparound_file_navigation boolean Have wraparound navigation or not

-- The full configuration for the plugin
---@class (exact) Configuration: UserConfiguration

-- The type for the state
---@class (exact) State
---@field config Configuration The configuration object

-- The type for the extractor function result
---@class (exact) ExtractionResult
---@field successful boolean Whether the extractor function was successful
---@field output string|nil The output of the extractor function
---@field cancelled boolean|nil boolean Whether the extraction was cancelled
---@field error string|nil The error message
---@field archive_path string|nil The path to the archive
---@field destination_path string|nil The path to the destination
---@field extracted_items_path string|nil The path to the extracted items
---@field extractor_name string|nil The name of the extractor

-- The name of the plugin
---@type string
local PLUGIN_NAME = "augment-command"

-- The enum for the supported commands
---@enum SupportedCommands
local Commands = {
	Open = "open",
	Extract = "extract",
	Enter = "enter",
	Leave = "leave",
	Rename = "rename",
	Remove = "remove",
	Create = "create",
	Shell = "shell",
	Paste = "paste",
	TabCreate = "tab_create",
	TabSwitch = "tab_switch",
	Quit = "quit",
	Arrow = "arrow",
	ParentArrow = "parent_arrow",
	Editor = "editor",
	Pager = "pager",
}

-- The enum for which group of items to operate on
---@enum ItemGroup
local ItemGroup = {
	Hovered = "hovered",
	Selected = "selected",
	None = "none",
	Prompt = "prompt",
}

-- The default configuration for the plugin
---@type UserConfiguration
local DEFAULT_CONFIG = {
	prompt = false,
	default_item_group_for_prompt = ItemGroup.Hovered,
	smart_enter = true,
	smart_paste = false,
	smart_tab_create = false,
	smart_tab_switch = false,
	confirm_on_quit = true,
	open_file_after_creation = false,
	enter_directory_after_creation = false,
	use_default_create_behaviour = false,
	enter_archives = true,
	extract_retries = 3,
	recursively_extract_archives = true,
	preserve_file_permissions = false,
	must_have_hovered_item = true,
	skip_single_subdirectory_on_enter = true,
	skip_single_subdirectory_on_leave = true,
	smooth_scrolling = false,
	scroll_delay = 0.02,
	wraparound_file_navigation = false,
}

-- The default input options for this plugin
local DEFAULT_INPUT_OPTIONS = {
	position = { "top-center", x = 0, y = 2, w = 50, h = 3 },
}

-- The default confirm options for this plugin
local DEFAULT_CONFIRM_OPTIONS = {
	pos = { "center", x = 0, y = 0, w = 50, h = 15 },
}

-- The default notification options for this plugin
local DEFAULT_NOTIFICATION_OPTIONS = {
	title = "Augment Command Plugin",
	timeout = 5,
}

-- The tab preference keys.
-- The values are just dummy values
-- so that I don't have to maintain two
-- different types for the same thing.
---@type tab.Preference
local TAB_PREFERENCE_KEYS = {
	sort_by = "alphabetical",
	sort_sensitive = false,
	sort_reverse = false,
	sort_dir_first = true,
	sort_translit = false,
	linemode = "none",
	show_hidden = false,
}

-- The table of input options for the prompt
---@type table<ItemGroup, string>
local INPUT_OPTIONS_TABLE = {
	[ItemGroup.Hovered] = "(H/s)",
	[ItemGroup.Selected] = "(h/S)",
	[ItemGroup.None] = "(h/s)",
}

-- The extractor names
---@enum ExtractorName
local ExtractorName = {
	SevenZip = "7-Zip",
	Tar = "Tar",
}

-- The extract behaviour flags
---@enum ExtractBehaviour
local ExtractBehaviour = {
	Overwrite = "overwrite",
	Rename = "rename",
}

-- The list of archive file extensions
---@type table<string, boolean>
local ARCHIVE_FILE_EXTENSIONS = {
	["7z"] = true,
	boz = true,
	bz = true,
	bz2 = true,
	bzip2 = true,
	cb7 = true,
	cbr = true,
	cbt = true,
	cbz = true,
	gz = true,
	gzip = true,
	rar = true,
	s7z = true,
	tar = true,
	tbz = true,
	tbz2 = true,
	tgz = true,
	txz = true,
	xz = true,
	zip = true,
}

-- The error for the base extractor class
-- which is an abstract base class that
-- does not implement any functionality
---@type string
local BASE_EXTRACTOR_ERROR = table.concat({
	"The Extractor class is does not implement any functionality.",
	"How did you even manage to get here?",
}, "\n")

-- Class definitions

-- The base extractor that all extractors inherit from
---@class Extractor
---@field name string The name of the extractor
---@field command string The shell command for the extractor
---@field commands string[] The possible extractor commands
---
--- Whether the extractor supports preserving file permissions
---@field supports_file_permissions boolean
---
--- The map of the extract behaviour strings to the command flags
---@field extract_behaviour_map table<ExtractBehaviour, string>
local Extractor = {
	name = "BaseExtractor",
	command = "",
	commands = {},
	supports_file_permissions = false,
	extract_behaviour_map = {},
}

-- The function to create a subclass of the abstract base extractor
---@param subclass table The subclass to create
---@return Extractor subclass Subclass of the base extractor
function Extractor:subclass(subclass)
	--

	-- Create a new instance
	local instance = setmetatable(subclass or {}, self)

	-- Set where to find the object's methods or properties
	self.__index = self

	-- Return the instance
	return instance
end

-- The method to get the archive items
---@type ExtractorGetItems
function Extractor:get_items() return {}, {}, BASE_EXTRACTOR_ERROR end

-- The method to extract the archive
---@type ExtractorExtract
function Extractor:extract(_)
	return {
		successful = false,
		error = BASE_EXTRACTOR_ERROR,
	}
end

-- The 7-Zip extractor
---@class SevenZip: Extractor
---@field password string The password to the archive
local SevenZip = Extractor:subclass({
	name = ExtractorName.SevenZip,
	commands = { "7z", "7zz" },

	-- https://documentation.help/7-Zip/overwrite.htm
	extract_behaviour_map = {
		[ExtractBehaviour.Overwrite] = "-aoa",
		[ExtractBehaviour.Rename] = "-aou",
	},

	password = "",
})

-- The Tar extractor
---@class Tar: Extractor
local Tar = Extractor:subclass({
	name = ExtractorName.Tar,
	commands = { "gtar", "tar" },
	supports_file_permissions = true,

	-- https://www.man7.org/linux/man-pages/man1/tar.1.html
	-- https://ss64.com/mac/tar.html
	extract_behaviour_map = {

		-- Tar overwrites by default
		[ExtractBehaviour.Overwrite] = "",
		[ExtractBehaviour.Rename] = "-k",
	},
})

-- The default extractor, which is set to 7-Zip
---@class DefaultExtractor: SevenZip
local DefaultExtractor = SevenZip:subclass({})

-- The table of archive mime types
---@type table<string, Extractor>
local ARCHIVE_MIME_TYPE_TO_EXTRACTOR_MAP = {
	["application/zip"] = DefaultExtractor,
	["application/gzip"] = DefaultExtractor,
	["application/tar"] = Tar,
	["application/bzip"] = DefaultExtractor,
	["application/bzip2"] = DefaultExtractor,
	["application/7z-compressed"] = DefaultExtractor,
	["application/rar"] = DefaultExtractor,
	["application/xz"] = DefaultExtractor,
}

-- Patterns

-- The list of mime type prefixes to remove
--
-- The prefixes are used in a lua pattern
-- to match on the mime type, so special
-- characters need to be escaped
---@type string[]
local MIME_TYPE_PREFIXES_TO_REMOVE = {
	"x%-",
	"vnd%.",
}

-- The pattern template to get the mime type without a prefix
---@type string
local get_mime_type_without_prefix_template_pattern =
	"^(%%a-)/%s([%%-%%d%%a]-)$"

-- The pattern to get the file extension
---@type string
local file_extension_pattern = "%.([%a]+)$"

-- The pattern to get the shell variables in a command
---@type string
local shell_variable_pattern = "[%$%%][%*@0]"

-- The pattern to match the bat command
---@type string
local bat_command_pattern = "%f[%a]bat%f[%A]"

-- Utility functions

-- Function to merge tables.
--
-- The key-value pairs of the tables given later
-- in the argument list WILL OVERRIDE
-- the tables given earlier in the argument list.
--
-- The list items in the table will be added in order,
-- with the items in the first table being added first,
-- and the items in the second table being added second,
-- and so on.
---@param ... table<any, any>[] The tables to merge
---@return table<any, any> merged_table The merged table
local function merge_tables(...)
	--

	-- Initialise a new table
	local new_table = {}

	-- Initialise the index variable
	local index = 1

	-- Iterates over the tables given
	for _, table in ipairs({ ... }) do
		--

		-- Iterate over all of the keys and values
		for key, value in pairs(table) do
			--

			-- If the key is a number, then add using the index
			-- instead of the key.
			-- This is to allow lists to be merged.
			if type(key) == "number" then
				--

				-- Set the value mapped to the index
				new_table[index] = value

				-- Increment the index
				index = index + 1

			-- Otherwise, the key isn't a number
			else
				--

				-- Set the key in the new table to the value given
				new_table[key] = value
			end
		end
	end

	-- Return the new table
	return new_table
end

-- Function to split a string into a list
---@param given_string string The string to split
---@param separator string|nil The character to split the string by
---@return string[] splitted_strings The list of strings split by the character
local function string_split(given_string, separator)
	--

	-- If the separator isn't given, set it to the whitespace character
	separator = separator or "%s"

	-- Initialise the list of splitted strings
	local splitted_strings = {}

	-- Iterate over all of the strings found by pattern
	for string in string.gmatch(given_string, "([^" .. separator .. "]+)") do
		--

		-- Add the string to the list of splitted strings
		table.insert(splitted_strings, string)
	end

	-- Return the list of splitted strings
	return splitted_strings
end

-- Function to trim a string
---@param string string The string to trim
---@return string trimmed_string The trimmed string
local function string_trim(string)
	--

	-- Return the string with the whitespace characters
	-- removed from the start and end
	return string:match("^%s*(.-)%s*$")
end

-- Function to get a value from a table
-- and return the default value if the key doesn't exist
---@param table table The table to get the value from
---@param key string|number The key to get the value from
---@param default any The default value to return if the key doesn't exist
local function table_get(table, key, default) return table[key] or default end

-- Function to pop a key from a table
---@param table table The table to pop from
---@param key string|number The key to pop
---@param default any The default value to return if the key doesn't exist
---@return any value The value of the key or the default value
local function table_pop(table, key, default)
	--

	-- Get the value of the key from the table
	local value = table[key]

	-- Remove the key from the table
	table[key] = nil

	-- Return the value if it exist,
	-- otherwise return the default value
	return value or default
end

-- Function to escape a percentage sign %
-- in the string that is being replaced
---@param replacement_string string The string to escape
---@return string replacement_result The escaped string
local function escape_replacement_string(replacement_string)
	--

	-- Get the result of the replacement
	local replacement_result = replacement_string:gsub("%%", "%%%%")

	-- Return the result of the replacement
	return replacement_result
end

-- Function to parse the number arguments to the number type
---@param args Arguments The arguments to parse
---@return Arguments parsed_args The parsed arguments
local function parse_number_arguments(args)
	--

	-- The parsed arguments
	---@type Arguments
	local parsed_args = {}

	-- Iterate over the arguments given
	for arg_name, arg_value in pairs(args) do
		--

		-- Try to convert the argument to a number
		local number_arg_value = tonumber(arg_value)

		-- Set the argument to the number argument value
		-- if the argument is a number,
		-- otherwise just set it to the given argument value
		parsed_args[arg_name] = number_arg_value or arg_value
	end

	-- Return the parsed arguments
	return parsed_args
end

-- Function to convert a table of arguments to a string
---@param args Arguments The arguments to convert
---@return string args_string The string of the arguments
local function convert_arguments_to_string(args)
	--

	-- The table of string arguments
	---@type string[]
	local string_arguments = {}

	-- Iterate all the items in the argument table
	for key, value in pairs(args) do
		--

		-- If the key is a number
		if type(key) == "number" then
			--

			-- Add the stringified value to the string arguments table
			table.insert(string_arguments, tostring(value))

		-- Otherwise, if the key is a string
		elseif type(key) == "string" then
			--

			-- Replace the underscores and spaces in the key with dashes
			local key_with_dashes = key:gsub("_", "-"):gsub("%s", "-")

			-- If the value is a boolean and the boolean is true,
			-- add the value to the string
			if type(value) == "boolean" and value then
				table.insert(
					string_arguments,
					string.format("--%s", key_with_dashes)
				)

			-- Otherwise, just add the key and the value to the string
			else
				table.insert(
					string_arguments,
					string.format("--%s=%s", key_with_dashes, value)
				)
			end
		end
	end

	-- Combine the string arguments into a single string
	local string_args = table.concat(string_arguments, " ")

	-- Return the string arguments
	return string_args
end

-- Function to show a warning
---@param warning_message any The warning message
---@param options YaziNotificationOptions|nil Options for the notification
---@return nil
local function show_warning(warning_message, options)
	return ya.notify(merge_tables(DEFAULT_NOTIFICATION_OPTIONS, options or {}, {
		content = tostring(warning_message),
		level = "warn",
	}))
end

-- Function to show an error
---@param error_message any The error message
---@param options YaziNotificationOptions|nil Options for the notification
---@return nil
local function show_error(error_message, options)
	return ya.notify(merge_tables(DEFAULT_NOTIFICATION_OPTIONS, options or {}, {
		content = tostring(error_message),
		level = "error",
	}))
end

-- Function to get the user's input
---@param prompt string The prompt to show to the user
---@param options YaziInputOptions|nil Options for the input
---@return string|nil user_input The user's input
---@return InputEvent event The event for the input function
local function get_user_input(prompt, options)
	return ya.input(merge_tables(DEFAULT_INPUT_OPTIONS, options or {}, {
		title = prompt,
	}))
end

-- Function to get the user's confirmation
---@param title string|ui.Line The title of the confirmation prompt
---@param content string|ui.Text The content of the confirmation prompt
---@return boolean confirmation Whether the user has confirmed or not
local function get_user_confirmation(title, content)
	--

	-- Get the user's confirmation
	local confirmation = ya.confirm(merge_tables(DEFAULT_CONFIRM_OPTIONS, {
		title = title,
		content = content,
	}))

	-- Return the result of the confirmation
	return confirmation
end

-- Function to merge the given configuration table with the default one
---@param config UserConfiguration|nil The configuration table to merge
---@return UserConfiguration merged_config The merged configuration table
local function merge_configuration(config)
	--

	-- If the configuration isn't given, then use the default one
	if config == nil then return DEFAULT_CONFIG end

	-- Initialise the list of invalid configuration options
	local invalid_configuration_options = {}

	-- Initialise the merged configuration
	local merged_config = {}

	-- Iterate over the default configuration table
	for key, value in pairs(DEFAULT_CONFIG) do
		--

		-- Add the default configuration to the merged configuration
		merged_config[key] = value
	end

	-- Iterate over the given configuration table
	for key, value in pairs(config) do
		--

		-- If the key is not in the merged configuration
		if merged_config[key] == nil then
			--

			-- Add the key to the list of invalid configuration options
			table.insert(invalid_configuration_options, key)

			-- Continue the loop
			goto continue
		end

		-- Otherwise, overwrite the value in the merged configuration
		merged_config[key] = value

		-- The label to continue the loop
		::continue::
	end

	-- If there are no invalid configuration options,
	-- then return the merged configuration
	if #invalid_configuration_options <= 0 then return merged_config end

	-- Otherwise, warn the user of the invalid configuration options
	show_warning(
		"Invalid configuration options: "
			.. table.concat(invalid_configuration_options, ", ")
	)

	-- Return the merged configuration
	return merged_config
end

-- Function to initialise the configuration
---@type fun(
---	user_config: Configuration|nil,    -- The configuration object
---): Configuration The initialised configuration object
local initialise_config = ya.sync(function(state, user_config)
	--

	-- Merge the default configuration with the user given one,
	-- as well as the additional data given,
	-- and set it to the state.
	state.config = merge_configuration(user_config)

	-- Return the configuration object for async functions
	return state.config
end)

-- Function to try if a shell command exists
---@param shell_command string The shell command to check
---@param args string[]|nil The arguments to the shell command
---@return boolean shell_command_exists Whether the shell command exists
local function async_shell_command_exists(shell_command, args)
	--

	-- Get the output of the shell command with the given arguments
	local output = Command(shell_command)
		:args(args or {})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	-- Return true if there's an output and false otherwise
	return output ~= nil
end

-- Function to emit a plugin command
---@param command string The plugin command to emit
---@param args Arguments The arguments to pass to the plugin command
---@return nil
local function emit_plugin_command(command, args)
	return ya.mgr_emit("plugin", {
		PLUGIN_NAME,
		string.format("%s %s", command, convert_arguments_to_string(args)),
	})
end

-- Function to subscribe to the augmented-extract event
---@type fun(): nil
local subscribe_to_augmented_extract_event = ya.sync(function(_)
	return ps.sub_remote("augmented-extract", function(args)
		--

		-- If the arguments given isn't a table,
		-- exit the function
		if type(args) ~= "table" then return end

		-- Iterate over the arguments
		for _, arg in ipairs(args) do
			--

			-- Emit the command to call the plugin's extract function
			-- with the given arguments and flags
			emit_plugin_command("extract", {
				archive_path = ya.quote(arg),
			})
		end
	end)
end)

-- Function to initialise the plugin
---@param opts Configuration|nil The options given to the plugin
---@return Configuration config The initialised configuration object
local function initialise_plugin(opts)
	--

	-- Subscribe to the augmented extract event
	subscribe_to_augmented_extract_event()

	-- Initialise the configuration object
	local config = initialise_config(opts)

	-- Return the configuration object
	return config
end

-- Function to standardise the mime type of a file.
-- This function will follow what Yazi does to standardise
-- mime types returned by the file command.
---@param mime_type string The mime type of the file
---@return string standardised_mime_type The standardised mime type of the file
local function standardise_mime_type(mime_type)
	--

	-- Trim the whitespace from the mime type
	local trimmed_mime_type = string_trim(mime_type)

	-- Iterate over the mime type prefixes to remove
	for _, prefix in ipairs(MIME_TYPE_PREFIXES_TO_REMOVE) do
		--

		-- Get the pattern to remove the mime type prefix
		local pattern =
			get_mime_type_without_prefix_template_pattern:format(prefix)

		-- Remove the prefix from the mime type
		local mime_type_without_prefix, replacement_count =
			trimmed_mime_type:gsub(pattern, "%1/%2")

		-- If the replacement count is greater than zero,
		-- return the mime type without the prefix
		if replacement_count > 0 then return mime_type_without_prefix end
	end

	-- Return the mime type with whitespace removed
	return trimmed_mime_type
end

-- Function to check if a given mime type is an archive
---@param mime_type string|nil The mime type of the file
---@return boolean is_archive Whether the mime type is an archive
local function is_archive_mime_type(mime_type)
	--

	-- If the mime type is nil, return false
	if not mime_type then return false end

	-- Standardise the mime type
	local standardised_mime_type = standardise_mime_type(mime_type)

	-- Get the archive extractor for the mime type
	local archive_extractor =
		ARCHIVE_MIME_TYPE_TO_EXTRACTOR_MAP[standardised_mime_type]

	-- Return if an extractor exists for the mime type
	return archive_extractor ~= nil
end

-- Function to check if a given file extension
-- is an archive file extension
---@param file_extension string|nil The file extension of the file
---@return boolean is_archive Whether the file extension is an archive
local function is_archive_file_extension(file_extension)
	--

	-- If the file extension is nil, return false
	if not file_extension then return false end

	-- Make the file extension lower case
	file_extension = file_extension:lower()

	-- Trim the whitespace from the file extension
	file_extension = string_trim(file_extension)

	-- Get if the file extension is an archive
	local is_archive = table_get(ARCHIVE_FILE_EXTENSIONS, file_extension, false)

	-- Return if the file extension is an archive file extension
	return is_archive
end

-- Function to get the mime type of a file
---@param file_path string The path to the file
---@return string mime_type The mime type of the file
local function get_mime_type(file_path)
	--

	-- Get the output of the file command
	local output, _ = Command("file")
		:args({

			-- Don't prepend file names to the output
			"-b",

			-- Print the mime type of the file
			"--mime-type",

			-- The file path to get the mime type of
			file_path,
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	-- If there is no output, then return an empty string
	if not output then return "" end

	-- Otherwise, get the mime type from the standard output
	local mime_type = string_trim(output.stdout)

	-- Standardise the mime type
	local standardised_mime_type = standardise_mime_type(mime_type)

	-- Return the standardised mime type
	return standardised_mime_type
end

-- Function to get a temporary name.
-- The code is taken from Yazi's source code.
---@param path string The path to the item to create a temporary name
---@return string temporary_name The temporary name for the item
local function get_temporary_name(path)
	return ".tmp_"
		.. ya.hash(string.format("extract//%s//%.10f", path, ya.time()))
end

-- Function to get a temporary directory url
-- for the given file path
---@param path string The path to the item to create a temporary directory
---@param destination_given boolean|nil Whether the destination was given
---@return Url|nil url The url of the temporary directory
local function get_temporary_directory_url(path, destination_given)
	--

	-- Get the url of the path given
	---@type Url
	local path_url = Url(path)

	-- Initialise the parent directory to be the path given
	---@type Url
	local parent_directory_url = path_url

	-- If the destination is not given
	if not destination_given then
		--

		-- Get the parent directory of the given path
		parent_directory_url = Url(path):parent()

		-- If the parent directory doesn't exist, return nil
		if not parent_directory_url then return nil end
	end

	-- Create the temporary directory path
	local temporary_directory_url =
		fs.unique_name(parent_directory_url:join(get_temporary_name(path)))

	-- Return the temporary directory path
	return temporary_directory_url
end

-- Function to get the configuration from an async function
---@type fun(): Configuration The configuration object
local get_config = ya.sync(function(state)
	--

	-- Returns the configuration object
	return state.config
end)

-- Function to get the current working directory
---@type fun(): string Returns the current working directory as a string
local get_current_directory = ya.sync(
	function(_) return tostring(cx.active.current.cwd) end
)

-- Function to get the path of the hovered item
---@type fun(
---	quote: boolean|nil,    -- Whether to escape the characters in the path
---): string|nil The path of the hovered item
local get_path_of_hovered_item = ya.sync(function(_, quote)
	--

	-- Get the hovered item
	local hovered_item = cx.active.current.hovered

	-- If there is no hovered item, exit the function
	if not hovered_item then return end

	-- Convert the url of the hovered item to a string
	local hovered_item_path = tostring(cx.active.current.hovered.url)

	-- If the quote flag is passed,
	-- then quote the path of the hovered item
	if quote then hovered_item_path = ya.quote(hovered_item_path) end

	-- Return the path of the hovered item
	return hovered_item_path
end)

-- Function to get if the hovered item is a directory
---@type fun(): boolean
local hovered_item_is_dir = ya.sync(function(_)
	--

	-- Get the hovered item
	local hovered_item = cx.active.current.hovered

	-- Return if the hovered item exists and is a directory
	return hovered_item and hovered_item.cha.is_dir
end)

-- Function to get if the hovered item is an archive
---@type fun(): boolean
local hovered_item_is_archive = ya.sync(function(_)
	--

	-- Get the hovered item
	local hovered_item = cx.active.current.hovered

	-- Return if the hovered item exists and is an archive
	return hovered_item and is_archive_mime_type(hovered_item:mime())
end)

-- Function to get the paths of the selected items
---@type fun(
---	quote: boolean|nil,    -- Whether to escape the characters in the path
---): string[]|nil The list of paths of the selected items
local get_paths_of_selected_items = ya.sync(function(_, quote)
	--

	-- Get the selected items
	local selected_items = cx.active.selected

	-- If there are no selected items, exit the function
	if #selected_items == 0 then return end

	-- Initialise the list of paths of the selected items
	local paths_of_selected_items = {}

	-- Iterate over the selected items
	for _, item in pairs(selected_items) do
		--

		-- Convert the url of the item to a string
		local item_path = tostring(item)

		-- If the quote flag is passed,
		-- then quote the path of the item
		if quote then item_path = ya.quote(item_path) end

		-- Add the path of the item to the list of paths
		table.insert(paths_of_selected_items, item_path)
	end

	-- Return the list of paths of the selected items
	return paths_of_selected_items
end)

-- Function to get the number of tabs currently open
---@type fun(): number
local get_number_of_tabs = ya.sync(function() return #cx.tabs end)

-- Function to get the tab preferences
---@type fun(): tab.Preference
local get_tab_preferences = ya.sync(function(_)
	--

	-- Create the table to store the tab preferences
	local tab_preferences = {}

	-- Iterate over the tab preference keys
	for key, _ in pairs(TAB_PREFERENCE_KEYS) do
		--

		-- Set the key in the table to the value
		-- from the state
		tab_preferences[key] = cx.active.pref[key]
	end

	-- Return the tab preferences
	return tab_preferences
end)

-- Function to get if Yazi is loading
---@type fun(): boolean
local yazi_is_loading = ya.sync(
	function(_) return cx.active.current.stage.is_loading end
)

-- Function to wait until Yazi is loaded
---@return nil
local function wait_until_yazi_is_loaded()
	while yazi_is_loading() do
	end
end

-- Function to choose which group of items to operate on.
-- It returns ItemGroup.Hovered for the hovered item,
-- ItemGroup.Selected for the selected items,
-- and ItemGroup.Prompt to tell the calling function
-- to prompt the user.
---@type fun(): ItemGroup|nil The desired item group
local get_item_group_from_state = ya.sync(function(state)
	--

	-- Get the hovered item
	local hovered_item = cx.active.current.hovered

	-- The boolean representing that there are no selected items
	local no_selected_items = #cx.active.selected == 0

	-- If there is no hovered item
	if not hovered_item then
		--

		-- If there are no selected items, exit the function
		if no_selected_items then
			return

		-- Otherwise, if the configuration is set to have a hovered item,
		-- exit the function
		elseif state.config.must_have_hovered_item then
			return

		-- Otherwise, return the enum for the selected items
		else
			return ItemGroup.Selected
		end

	-- Otherwise, there is a hovered item
	-- and if there are no selected items,
	-- return the enum for the hovered item.
	elseif no_selected_items then
		return ItemGroup.Hovered

	-- Otherwise if there are selected items and the user wants a prompt,
	-- then tells the calling function to prompt them
	elseif state.config.prompt then
		return ItemGroup.Prompt

	-- Otherwise, if the hovered item is selected,
	-- then return the enum for the selected items
	elseif hovered_item:is_selected() then
		return ItemGroup.Selected

	-- Otherwise, return the enum for the hovered item
	else
		return ItemGroup.Hovered
	end
end)

-- Function to prompt the user for their desired item group
---@return ItemGroup|nil item_group The item group selected by the user
local function prompt_for_desired_item_group()
	--

	-- Get the configuration
	local config = get_config()

	-- Get the default item group
	---@type ItemGroup|nil
	local default_item_group = config.default_item_group_for_prompt

	-- Get the input options
	local input_options = INPUT_OPTIONS_TABLE[default_item_group]

	-- If the default item group is None, then set it to nil
	if default_item_group == ItemGroup.None then default_item_group = nil end

	-- Prompt the user for their input
	local user_input, event = get_user_input(
		"Operate on hovered or selected items? " .. input_options
	)

	-- If the user input is empty, then exit the function
	if not user_input then return end

	-- Lowercase the user's input
	user_input = user_input:lower()

	-- If the user did not confirm the input, exit the function
	if event ~= 1 then
		return

	-- Otherwise, if the user's input starts with "h",
	-- return the item group representing the hovered item
	elseif user_input:find("^h") then
		return ItemGroup.Hovered

	-- Otherwise, if the user's input starts with "s",
	-- return the item group representing the selected items
	elseif user_input:find("^s") then
		return ItemGroup.Selected

	-- Otherwise, return the default item group
	else
		return default_item_group
	end
end

-- Function to get the item group
---@return ItemGroup|nil item_group The desired item group
local function get_item_group()
	--

	-- Get the item group from the state
	local item_group = get_item_group_from_state()

	-- If the item group isn't the prompt one,
	-- then return the item group immediately
	if item_group ~= ItemGroup.Prompt then
		return item_group

	-- Otherwise, prompt the user for the desired item group
	else
		return prompt_for_desired_item_group()
	end
end

-- Function to get all the items in the given directory
---@param directory_path string The path to the directory
---@param get_hidden_items boolean Whether to get hidden items
---@param directories_only boolean|nil Whether to only get directories
---@return string[] directory_items The list of urls to the directory items
local function get_directory_items(
	directory_path,
	get_hidden_items,
	directories_only
)
	--

	-- Initialise the list of directory items
	---@type string[]
	local directory_items = {}

	-- Read the contents of the directory
	local directory_contents, _ = fs.read_dir(Url(directory_path), {})

	-- If there are no directory contents,
	-- then return the empty list of directory items
	if not directory_contents then return directory_items end

	-- Iterate over the directory contents
	for _, item in ipairs(directory_contents) do
		--

		-- If the get hidden items flag is set to false
		-- and the item is a hidden item,
		-- then continue the loop
		if not get_hidden_items and item.cha.is_hidden then goto continue end

		-- If the directories only flag is passed
		-- and the item is not a directory,
		-- then continue the loop
		if directories_only and not item.cha.is_dir then goto continue end

		-- Otherwise, add the item path to the list of directory items
		table.insert(directory_items, tostring(item.url))

		-- The continue label to continue the loop
		::continue::
	end

	-- Return the list of directory items
	return directory_items
end

-- Function to skip child directories with only one directory
---@param initial_directory_path string The path of the initial directory
---@return nil
local function skip_single_child_directories(initial_directory_path)
	--

	-- Initialise the directory variable to the initial directory given
	local directory = initial_directory_path

	-- Get the tab preferences
	local tab_preferences = get_tab_preferences()

	-- Start an infinite loop
	while true do
		--

		-- Get all the items in the current directory
		local directory_items =
			get_directory_items(directory, tab_preferences.show_hidden)

		-- If the number of directory items is not 1,
		-- then break out of the loop.
		if #directory_items ~= 1 then break end

		-- Otherwise, get the directory item
		local directory_item = table.unpack(directory_items)

		-- Get the cha object of the directory item
		-- and don't follow symbolic links
		local directory_item_cha = fs.cha(Url(directory_item), false)

		-- If the cha object of the directory item is nil
		-- then break the loop
		if not directory_item_cha then break end

		-- If the directory item is not a directory,
		-- break the loop
		if not directory_item_cha.is_dir then break end

		-- Otherwise, set the directory to the inner directory
		directory = directory_item
	end

	-- Emit the change directory command to change to the directory variable
	ya.mgr_emit("cd", { directory })
end

-- Class implementations

-- The function to create a new instance of the extractor
---@param archive_path string The path to the archive
---@param destination_path string|nil The path to extract to
---@param config Configuration The configuration object
---@return Extractor|nil instance An instance of the extractor if available
function Extractor:new(archive_path, destination_path, config)
	--

	-- Initialise whether the extractor is available
	local available = false

	-- Iterate over the commands
	for _, command in ipairs(self.commands) do
		--

		-- Call the shell command exists function
		-- on the command
		local exists = async_shell_command_exists(command)

		-- If the command exists
		if exists then
			--

			-- Save the command
			self.command = command

			-- Set the available variable to true
			available = true

			-- Break out of the loop
			break
		end
	end

	-- If none of the commands for the extractor are available,
	-- then return nil
	if not available then return nil end

	-- Otherwise, create a new instance
	local instance = setmetatable({}, self)

	-- Set where to find the object's methods or properties
	self.__index = self

	-- Save the parameters given
	self.archive_path = archive_path
	self.destination_path = destination_path
	self.config = config

	-- Return the instance
	return instance
end

-- Function to retry the extractor
---@private
---@param extractor_function ExtractorCommand Extractor command to retry
---@param clean_up_wanted boolean|nil Whether to clean up the destination path
---@return ExtractionResult result Result of the extractor function
function SevenZip:retry_extractor(extractor_function, clean_up_wanted)
	--

	-- Initialise the number of tries
	-- to the number of retries plus 1
	local total_number_of_tries = self.config.extract_retries + 1

	-- Get the url of the archive
	---@type Url
	local archive_url = Url(self.archive_path)

	-- Get the archive name
	local archive_name = archive_url:name()

	-- If the archive name is nil,
	-- return the result of the extractor function
	if not archive_name then
		return {
			successful = false,
			error = string.format("%s does not have a name", self.archive_path),
		}
	end

	-- Initialise the initial password prompt
	local initial_password_prompt = string.format("%s password:", archive_name)

	-- Initialise the wrong password prompt
	local wrong_password_prompt =
		string.format("Wrong password, %s password:", archive_name)

	-- Initialise the clean up function
	local clean_up = clean_up_wanted
			and function() fs.remove("dir_all", Url(self.destination_path)) end
		or function() end

	-- Initialise the error message
	local error_message = nil

	-- Iterate over the number of times to try the extraction
	for tries = 0, total_number_of_tries do
		--

		-- Execute the extractor function
		local output, error = extractor_function()

		-- If there is no output
		if not output then
			--

			-- Clean up the extracted files
			clean_up()

			-- Return the result of the extractor function
			return {
				successful = false,
				error = tostring(error),
			}
		end

		-- If the output status code is 0,
		-- which means the command was successful,
		-- return the result of the extractor function
		if output.status.code == 0 then
			return {
				successful = true,
				output = output.stdout,
			}
		end

		-- Set the error message to the standard error
		error_message = output.stderr

		-- If the command failed for a reason other
		-- than the archive being encrypted,
		-- or if the current try count
		-- is the same as the total number of tries
		if
			not (
				output.status.code == 2
				and error_message:lower():find("wrong password")
			) or tries == total_number_of_tries
		then
			--

			-- Clean up the extracted files
			clean_up()

			-- Return the extractor function result
			return {
				successful = false,
				error = error_message,
			}
		end

		-- Otherwise, get the prompt for the password
		local password_prompt = tries == 0 and initial_password_prompt
			or wrong_password_prompt

		-- Initialise the width of the input element
		local input_width = DEFAULT_INPUT_OPTIONS.position.w

		-- If the length of the password prompt is larger
		-- than the default input with, set the input width
		-- to the length of the password prompt + 1
		if #password_prompt > input_width then
			input_width = #password_prompt + 1
		end

		-- Get the new position object
		-- for the new input element
		---@type Position
		local new_position =
			merge_tables(DEFAULT_INPUT_OPTIONS.position, { w = input_width })

		-- Ask the user for the password
		local user_input, event =
			---@diagnostic disable-next-line: missing-fields
			get_user_input(password_prompt, { position = new_position })

		-- If the user has confirmed the input,
		-- and the user input is not nil,
		-- set the password to the user's input
		if event == 1 and user_input ~= nil then
			self.password = user_input

		-- Otherwise
		else
			--

			-- Call the clean up function
			clean_up()

			-- Return the result of the extractor command
			return {
				successful = false,
				cancelled = true,
				error = error_message,
			}
		end
	end

	-- If all the tries have been exhausted,
	-- call the clean up function
	clean_up()

	-- Return the result of the extractor command
	return {
		successful = false,
		error = error_message,
	}
end

-- Function to list the archive items with the command
---@type ExtractorListItemsCommand
function SevenZip:list_items_command()
	--

	-- Initialise the arguments for the command
	local arguments = {

		-- List the items in the archive
		"l",

		-- Use UTF-8 encoding for console input and output
		"-sccUTF-8",

		-- Pass the password to the command
		"-p" .. self.password,

		-- Remove the headers (undocumented switch)
		"-ba",

		-- The archive path
		self.archive_path,
	}

	-- Return the result of the command to list the items in the archive
	return Command(self.command)
		:args(arguments)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
end

-- Function to get the items in the archive
---@type ExtractorGetItems
function SevenZip:get_items()
	--

	-- Initialise the list of files in the archive
	---@type string[]
	local files = {}

	-- Initialise the list of directories
	---@type string[]
	local directories = {}

	-- Call the function to retry the extractor command
	-- with the list items in the archive function
	local extractor_result = self:retry_extractor(
		function() return self:list_items_command() end
	)

	-- Get the output
	local output = extractor_result.output

	-- Get the error
	local error = extractor_result.error

	-- If the extractor command was not successful,
	-- or the output was nil,
	-- then return nil the error message,
	-- and nil as the correct password
	if not extractor_result.successful or not output then
		return files, directories, error
	end

	-- Otherwise, split the output at the newline character
	local output_lines = string_split(output, "\n")

	-- The pattern to get the information from an archive item
	---@type string
	local archive_item_info_pattern = "%s+([%.%a]+)%s+(%d+)%s+(%d+)%s+(.+)$"

	-- Iterate over the lines of the output
	for _, line in ipairs(output_lines) do
		--

		-- Get the information about the archive item from the line.
		-- The information is in the format:
		-- Attributes, Size, Compressed Size, File Path
		local attributes, _, _, file_path =
			line:match(archive_item_info_pattern)

		-- If the file path doesn't exist, then continue the loop
		if not file_path then goto continue end

		-- If the attributes of the item starts with a "D",
		-- which means the item is a directory
		if attributes and attributes:find("^D") then
			--

			-- Add the directory to the list of directories
			table.insert(directories, file_path)

			-- Continue the loop
			goto continue
		end

		-- Otherwise, add the file path to the list of archive items
		table.insert(files, file_path)

		-- The continue label to continue the loop
		::continue::
	end

	-- Return the list of files, the list of directories,
	-- the error message, and the password
	return files, directories, error
end

-- Function to extract an archive using the command
---@param extract_files_only boolean|nil Extract the files only or not
---@param extract_behaviour ExtractBehaviour|nil The extraction behaviour
---@return CommandOutput|nil output The output of the command
---@return Error|nil error The error if any
function SevenZip:extract_command(extract_files_only, extract_behaviour)
	--

	-- Initialise the extract files only flag to false if it's not given
	extract_files_only = extract_files_only or false

	-- Initialise the extract behaviour to rename if it's not given
	extract_behaviour =
		self.extract_behaviour_map[extract_behaviour or ExtractBehaviour.Rename]

	-- Initialise the extraction mode to use.
	-- By default, it extracts the archive with
	-- full paths, which keeps the archive structure.
	local extraction_mode = "x"

	-- If the extract files only flag is passed
	if extract_files_only then
		--

		-- Use the regular extract,
		-- without the full paths, which will move
		-- all files in the archive into the current directory
		-- and ignore the archive folder structure.
		extraction_mode = "e"
	end

	-- Initialise the arguments for the command
	local arguments = {

		-- The extraction mode
		extraction_mode,

		-- Assume yes to all prompts
		"-y",

		-- Use UTF-8 encoding for console input and output
		"-sccUTF-8",

		-- Configure the extraction behaviour
		extract_behaviour,

		-- Pass the password to the command
		"-p" .. self.password,

		-- The archive file to extract
		self.archive_path,

		-- The destination directory path
		"-o" .. self.destination_path,
	}

	-- Return the command to extract the archive
	return Command(self.command)
		:args(arguments)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
end

-- Function to extract the archive
---@type ExtractorExtract
function SevenZip:extract(has_only_one_file)
	--

	-- Extract the archive with the extractor command
	local result = self:retry_extractor(
		function() return self:extract_command(has_only_one_file) end,
		true
	)

	-- Return the extractor result
	return result
end

-- Function to list the archive items with the command
---@type ExtractorListItemsCommand
function Tar:list_items_command()
	--

	-- Initialise the arguments for the command
	local arguments = {

		-- List the items in the archive
		"-t",

		-- Pass the file
		"-f",

		-- The archive file path
		self.archive_path,
	}

	-- Return the result of the command
	return Command(self.command)
		:args(arguments)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
end

-- Function to get the items in the archive
---@type ExtractorGetItems
function Tar:get_items()
	--

	-- Call the function to get the list of items in the archive
	local output, error = self:list_items_command()

	-- Initialise the list of files
	---@type string[]
	local files = {}

	-- Initialise the list of directories
	---@type string[]
	local directories = {}

	-- If there is no output, return the empty lists and the error
	if not output then return files, directories, tostring(error) end

	-- Otherwise, split the output into lines and iterate over it
	for _, line in ipairs(string_split(output.stdout, "\n")) do
		--

		-- If the line ends with a slash, it's a directory
		if line:sub(-1) == "/" then
			--

			-- Add the directory without the trailing slash
			-- to the list of directories
			table.insert(directories, line:sub(1, -2))

			-- Continue the loop
			goto continue
		end

		-- Otherwise, the item is a file, so add it to the list of files
		table.insert(files, line)

		-- The label to continue the loop
		::continue::
	end

	-- Return the list of files and directories and the error
	return files, directories, output.stderr
end

-- Function to extract an archive using the command
---@param extract_behaviour ExtractBehaviour|nil The extract behaviour to use
function Tar:extract_command(extract_behaviour)
	--

	-- Initialise the extract behaviour to rename if it is not given
	extract_behaviour =
		self.extract_behaviour_map[extract_behaviour or ExtractBehaviour.Rename]

	-- Initialise the arguments for the command
	local arguments = {

		-- Extract the archive
		"-x",

		-- Verbose
		"-v",

		-- The extract behaviour flag
		extract_behaviour,

		-- Specify the destination directory
		"-C",

		-- The destination directory path
		self.destination_path,
	}

	-- If keeping permissions is wanted, add the -p flag
	if self.config.preserve_file_permissions then
		table.insert(arguments, "-p")
	end

	-- Add the -f flag and the archive path to the arguments
	table.insert(arguments, "-f")
	table.insert(arguments, self.archive_path)

	-- Create the destination path first.
	--
	-- This is required because tar does not
	-- automatically create the directory
	-- pointed to by the -C flag.
	-- Instead, tar just tries to change
	-- the working directory to the directory
	-- pointed to by the -C flag, which can
	-- fail if the directory does not exist.
	--
	-- GNU tar has a --one-top-level=[DIR] option,
	-- which will automatically create the directory
	-- given, but macOS tar does not have this option.
	--
	-- The error here is ignored because if there
	-- is an error creating the directory,
	-- then the extractor will fail anyway.
	fs.create("dir_all", Url(self.destination_path))

	-- Return the output of the command
	return Command(self.command)
		:args(arguments)
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()
end

-- Function to extract the archive.
--
-- Tar automatically decompresses and extracts the archive
-- in one command, so there's no need to run it twice to
-- extract compressed tarballs.
---@type ExtractorExtract
function Tar:extract(_)
	--

	-- Call the command to extract the archive
	local output, error = self:extract_command()

	-- If there is no output, return the result
	if not output then
		return {
			successful = false,
			error = tostring(error),
		}
	end

	-- Otherwise, if the status code is not 0,
	-- which means the extraction was not successful,
	-- return the result
	if output.status.code ~= 0 then
		return {
			successful = false,
			output = output.stdout,
			error = output.stderr,
		}
	end

	-- Otherwise, return the successful result
	return {
		successful = true,
		output = output.stdout,
	}
end

-- Functions for the commands

-- Function to get the extractor for the file type
---@param archive_path string The path to the archive file
---@param destination_path string The path to the destination directory
---@param config Configuration The configuration for the plugin
---@return ExtractionResult result The results of getting the extractor
---@return Extractor|nil extractor The extractor for the file type
local function get_extractor(archive_path, destination_path, config)
	--

	-- Get the mime type of the archive file
	local mime_type = get_mime_type(archive_path)

	-- Get the extractor for the mime type
	local extractor = ARCHIVE_MIME_TYPE_TO_EXTRACTOR_MAP[mime_type]

	-- If there is no extractor,
	-- return that it is not successful,
	-- but that it has been cancelled
	-- as the mime type is not an archive
	if not extractor then
		return {
			successful = false,
			cancelled = true,
		}
	end

	-- Instantiate an instance of the extractor
	local extractor_instance =
		extractor:new(archive_path, destination_path, config)

	-- While the extractor instance failed to be created
	while not extractor_instance do
		--

		-- If the extractor instance is the default extractor,
		-- then return an error telling the user to install the
		-- default extractor
		if extractor.name == DefaultExtractor.name then
			return {
				successful = false,
				error = table.concat({
					string.format(
						"%s is not installed,",
						DefaultExtractor.name
					),
					"please install it before using the 'extract' command",
				}, " "),
			}
		end

		-- Try instantiating the default extractor
		extractor_instance =
			DefaultExtractor:new(archive_path, destination_path, config)
	end

	-- If the user wants to preserve file permissions,
	-- and the target extractor for the mime type supports
	-- preserving file permissions, but the extractor
	-- instantiated does not, show a warning to the user
	if
		config.preserve_file_permissions
		and extractor.supports_file_permissions
		and not extractor_instance.supports_file_permissions
	then
		--

		-- The warning to show the user
		local warning = table.concat({
			string.format(
				"%s is not installed, defaulting to %s.",
				extractor.name,
				extractor_instance.name
			),
			string.format(
				"However, %s does not support preserving file permissions.",
				extractor_instance.name
			),
		}, "\n")

		-- Show the warning to the user
		show_warning(warning)
	end

	-- Return the extractor instance
	return { successful = true }, extractor_instance
end

-- Function to move the extracted items out of the temporary directory
---@param archive_url Url The url of the archive
---@param destination_url Url The url of the destination
---@return ExtractionResult result The result of the move
local function move_extracted_items(archive_url, destination_url)
	--

	-- The function to clean up the destination directory
	-- and return the extractor result in the event of an error
	---@param error string The error message to return
	---@param empty_dir_only boolean|nil Whether to remove the empty dir only
	---@return ExtractionResult
	local function fail(error, empty_dir_only)
		--

		-- Clean up the destination path
		fs.remove(empty_dir_only and "dir" or "dir_all", destination_url)

		-- Return the extractor result
		---@type ExtractionResult
		return {
			successful = false,
			error = error,
		}
	end

	-- Get the extracted items in the destination.
	-- There is a limit of 2 as we just need to
	-- know if the destination contains only
	-- a single item or not.
	local extracted_items = fs.read_dir(destination_url, { limit = 2 })

	-- If the extracted items doesn't exist,
	-- clean up and return the error
	if not extracted_items then
		return fail(
			string.format(
				"Failed to read the destination directory: %s",
				tostring(destination_url)
			)
		)
	end

	-- If there are no extracted items,
	-- clean up and return the error
	if #extracted_items == 0 then
		return fail("No files extracted from the archive", true)
	end

	-- Get the parent directory of the destination
	local parent_directory_url = destination_url:parent()

	-- If the parent directory doesn't exist,
	-- clean up and return the error
	if not parent_directory_url then
		return fail("Destination path has no parent directory")
	end

	-- Get the name of the archive without the extension
	local archive_name = archive_url:stem()

	-- If the name of the archive doesn't exist,
	-- clean up and return the error
	if not archive_name then
		return fail("Archive has no name without its extension")
	end

	-- Get the first extracted item
	local first_extracted_item = table.unpack(extracted_items)

	-- Initialise the variable to indicate whether the archive has only one item
	local only_one_item = false

	-- Initialise the target directory url to move the extracted items to,
	-- which is the parent directory of the archive
	-- joined with the file name of the archive without the extension
	local target_url = parent_directory_url:join(archive_name)

	-- If there is only one item in the archive
	if #extracted_items == 1 then
		--

		-- Set the only one item variable to true
		only_one_item = true

		-- Get the name of the first extracted item
		local first_extracted_item_name = first_extracted_item.url:name()

		-- If the first extracted item has no name,
		-- then clean up and return the error
		if not first_extracted_item_name then
			return fail("The only extracted item has no name")
		end

		-- Otherwise, set the target url to the parent directory
		-- of the destination joined with the file name of the extracted item
		target_url = parent_directory_url:join(first_extracted_item_name)
	end

	-- Get a unique name for the target url
	local unique_target_url = fs.unique_name(target_url)

	-- If the unique target url is nil,
	-- clean up and return the error
	if not unique_target_url then
		return fail(
			"Failed to get a unique name to move the extracted items to"
		)
	end

	-- Set the target path to the string of the target url
	local target_path = tostring(unique_target_url)

	-- Initialise the move successful variable and the error message
	local error_message, move_successful = nil, false

	-- If there is only one item in the archive
	if only_one_item then
		--

		-- Move the item to the target path
		move_successful, error_message =
			os.rename(tostring(first_extracted_item.url), target_path)

	-- Otherwise
	else
		--

		-- Rename the destination directory itself to the target path
		move_successful, error_message =
			os.rename(tostring(destination_url), target_path)
	end

	-- Clean up the destination directory
	fs.remove(move_successful and "dir" or "dir_all", destination_url)

	-- Return the extractor result with the target path as the
	-- path to the extracted items
	return {
		successful = move_successful,
		error = error_message,
		extracted_items_path = target_path,
	}
end

-- Function to recursively extract archives
---@param archive_path string The path to the archive
---@param args Arguments The arguments passed to the plugin
---@param config Configuration The configuration object
---@param destination_path string|nil The destination path to extract to
---@return ExtractionResult extraction_result The extraction results
local function recursively_extract_archive(
	archive_path,
	args,
	config,
	destination_path
)
	--

	-- Get whether the destination path is given
	local destination_path_given = destination_path ~= nil

	-- Initialise the destination path to the archive path if it is not given
	local destination = destination_path or archive_path

	-- Get the temporary directory url
	local temporary_directory_url =
		get_temporary_directory_url(destination, destination_path_given)

	-- If the temporary directory can't be created
	-- then return the result
	if not temporary_directory_url then
		return {
			successful = false,
			error = "Failed to create a temporary directory",
			archive_path = archive_path,
			destination_path = destination_path,
		}
	end

	-- Get an extractor for the archive
	local get_extractor_result, extractor =
		get_extractor(archive_path, tostring(temporary_directory_url), config)

	-- If there is no extractor, return the result
	if not extractor then
		return merge_tables(get_extractor_result, {
			archive_path = archive_path,
			destination_path = destination_path,
		})
	end

	-- Function to add additional information to the extraction result
	-- The additional information are:
	--      - The archive path
	--      - The destination path
	--      - The name of the extractor
	---@param result ExtractionResult The result to add the paths to
	---@return ExtractionResult modified_result The result with the paths added
	local function add_additional_info(result)
		return merge_tables(result, {
			archive_path = archive_path,
			destination_path = destination_path,
			extractor_name = extractor.name,
		})
	end

	-- Get the list of archive files and directories,
	-- the error message and the password
	local archive_files, archive_directories, error = extractor:get_items()

	-- If there are no are no archive files and directories
	if #archive_files == 0 and #archive_directories == 0 then
		--

		-- The extraction result
		---@type ExtractionResult
		local extraction_result = {
			successful = false,
			error = error or "Archive is empty",
		}

		-- Return the extraction result
		return add_additional_info(extraction_result)
	end

	-- Get if the archive has only one file
	local archive_has_only_one_file = #archive_files == 1
		and #archive_directories == 0

	-- Extract the given archive
	local extraction_result = extractor:extract(archive_has_only_one_file)

	-- If the extraction result is not successful, return it
	if not extraction_result.successful then
		return add_additional_info(extraction_result)
	end

	-- Get the result of moving the extracted items
	local move_result =
		move_extracted_items(Url(archive_path), temporary_directory_url)

	-- Get the extracted items path
	local extracted_items_path = move_result.extracted_items_path

	-- If moving the extracted items isn't successful,
	-- or if the extracted items path is nil,
	-- or if the user does not want to extract archives recursively,
	-- return the move results
	if
		not move_result.successful
		or not extracted_items_path
		or not config.recursively_extract_archives
	then
		return add_additional_info(move_result)
	end

	-- Get the url of the extracted items path
	---@type Url
	local extracted_items_url = Url(extracted_items_path)

	-- Initialise the base url for the extracted items
	local base_url = extracted_items_url

	-- Get the parent directory of the extracted items path
	local parent_directory_url = extracted_items_url:parent()

	-- If the parent directory doesn't exist
	if not parent_directory_url then
		--

		-- Modify the move result with a custom error
		---@type ExtractionResult
		local modified_move_result = merge_tables(move_result, {
			error = "Archive has no parent directory",
			archive_path = archive_path,
			destination_path = destination_path,
		})

		-- Return the modified move result
		return modified_move_result
	end

	-- If the archive has only one file
	if archive_has_only_one_file then
		--

		-- Set the base url to the parent directory of the extracted items path
		base_url = parent_directory_url
	end

	-- Iterate over the archive files
	for _, file in ipairs(archive_files) do
		--

		-- Get the file extension of the file
		local file_extension = file:match(file_extension_pattern)

		-- If the file extension is not found, then skip the file
		if not file_extension then goto continue end

		-- If the file extension is not an archive file extension, skip the file
		if not is_archive_file_extension(file_extension) then goto continue end

		-- Otherwise, get the full url to the archive
		local full_archive_url = base_url:join(file)

		-- Get the full path to the archive
		local full_archive_path = tostring(full_archive_url)

		-- Recursively extract the archive
		emit_plugin_command(
			"extract",
			merge_tables(args, {
				archive_path = ya.quote(full_archive_path),
				remove = true,
			})
		)

		-- The label the continue the loop
		::continue::
	end

	-- Return the move result
	return add_additional_info(move_result)
end

-- Function to show an extraction error
---@param extraction_result ExtractionResult The extraction result
---@return nil
local function show_extraction_error(extraction_result)
	--

	-- The line for the error
	local error_line = string.format("Error: %s", extraction_result.error)

	-- If the extractor name exists
	if extraction_result.extractor_name then
		--

		-- Add the extractor's name to the error
		error_line = string.format(
			"%s error: %s",
			extraction_result.extractor_name,
			extraction_result.error
		)
	end

	-- Show the extraction error
	return show_error(table.concat({
		string.format(
			"Failed to extract archive at: %s",
			extraction_result.archive_path
		),
		string.format("Destination: %s", extraction_result.destination_path),
		error_line,
	}, "\n"))
end

-- Function to handle the open command
---@type CommandFunction
local function handle_open(args, config)
	--

	-- Call the function to get the item group
	local item_group = get_item_group()

	-- If no item group is returned, exit the function
	if not item_group then return end

	-- If the item group is the selected items,
	-- then execute the command and exit the function
	if item_group == ItemGroup.Selected then
		--

		-- Emit the command and exit the function
		return ya.mgr_emit("open", args)
	end

	-- If the hovered item is a directory
	if hovered_item_is_dir() then
		--

		-- If smart enter is wanted,
		-- calls the function to enter the directory
		-- and exit the function
		if config.smart_enter or table_pop(args, "smart", false) then
			return emit_plugin_command("enter", args)
		end

		-- Otherwise, just exit the function
		return
	end

	-- Otherwise, if the hovered item is not an archive,
	-- or entering archives isn't wanted,
	-- or the interactive flag is passed
	if
		not hovered_item_is_archive()
		or not config.enter_archives
		or args.interactive
	then
		--

		-- Simply emit the open command,
		-- opening only the hovered item
		-- as the item group is the hovered item,
		-- and exit the function
		return ya.mgr_emit("open", merge_tables(args, { hovered = true }))
	end

	-- Otherwise, the hovered item is an archive
	-- and entering archives is wanted,
	-- so get the path of the hovered item
	local archive_path = get_path_of_hovered_item()

	-- If the archive path somehow doesn't exist, then exit the function
	if not archive_path then return end

	-- Get the parent directory of the hovered item
	---@type Url
	local parent_directory_url = Url(archive_path):parent()

	-- If the parent directory doesn't exist, then exit the function
	if not parent_directory_url then return end

	-- Emit the command to extract the archive
	-- and reveal the extracted items
	emit_plugin_command(
		"extract",
		merge_tables(args, {
			archive_path = ya.quote(archive_path),
			reveal = true,
			parent_dir = ya.quote(tostring(parent_directory_url)),
		})
	)
end

-- Function to get the archive paths for the extract command
---@param args Arguments The arguments passed to the plugin
---@return string|string[]|nil archive_paths The archive paths
local function get_archive_paths(args)
	--

	-- Get the archive path from the arguments given
	local archive_path = table_pop(args, "archive_path")

	-- If the archive path is given, return it immediately
	if archive_path then return archive_path end

	-- Otherwise, get the item group
	local item_group = get_item_group()

	-- If there is no item group
	if not item_group then return end

	-- If the item group is the hovered item
	if item_group == ItemGroup.Hovered then
		--

		-- Get the hovered item path
		local hovered_item_path = get_path_of_hovered_item(true)

		-- If the hovered item path is nil, exit the function
		if not hovered_item_path then return end

		-- Otherwise, return the hovered item path
		return hovered_item_path
	end

	-- Otherwise, if the item group is the selected items
	if item_group == ItemGroup.Selected then
		--

		-- Get the list of selected items
		local selected_items = get_paths_of_selected_items(true)

		-- If there are no selected items, exit the function
		if not selected_items then return end

		-- Otherwise, return the list of selected items
		return selected_items
	end
end

-- Function to handle the extract command
---@type CommandFunction
local function handle_extract(args, config)
	--

	-- Get the archive paths
	local archive_paths = get_archive_paths(args)

	-- Get the destination path from the arguments given
	---@type string
	local destination_path = table_pop(args, "destination_path")

	-- If there are no archive paths, exit the function
	if not archive_paths then return end

	-- If the archive path is a list
	if type(archive_paths) == "table" then
		--

		-- Iterate over the archive paths
		-- and call the extract command on them
		for _, archive_path in ipairs(archive_paths) do
			emit_plugin_command(
				"extract",
				merge_tables(args, {
					archive_path = ya.quote(archive_path),
				})
			)
		end

		-- Exit the function
		return
	end

	-- Otherwise the archive path is a string
	---@type string
	local archive_path = archive_paths

	-- Call the function to recursively extract the archive
	local extraction_result = recursively_extract_archive(
		archive_path,
		args,
		config,
		destination_path
	)

	-- If the extraction is cancelled, then just exit the function
	if extraction_result.cancelled then return end

	-- Get the extracted items path
	local extracted_items_path = extraction_result.extracted_items_path

	-- If the extraction is not successful, notify the user
	if not extraction_result.successful or not extracted_items_path then
		return show_extraction_error(extraction_result)
	end

	-- Get the url of the archive
	local archive_url = Url(archive_path)

	-- If the remove flag is passed,
	-- then remove the archive after extraction
	if table_pop(args, "remove", false) then fs.remove("file", archive_url) end

	-- If the reveal flag is passed
	if table_pop(args, "reveal", false) then
		--

		-- Get the url of the extracted items
		---@type Url
		local extracted_items_url = Url(extracted_items_path)

		-- Get the parent directory of the extracted items
		local parent_directory_url = extracted_items_url:parent()

		-- If the parent directory doesn't exist, then exit the function
		if not parent_directory_url then return end

		-- Get the given parent directory
		local given_parent_directory = table_pop(args, "parent_dir")

		-- If there is a parent directory given but the parent directory
		-- of the extracted items isn't the same as the given one,
		-- exit the function
		if
			given_parent_directory
			and given_parent_directory ~= tostring(parent_directory_url)
		then
			return
		end

		-- Get the cha of the extracted item
		local extracted_items_cha = fs.cha(extracted_items_url, false)

		-- If the cha of the extracted item doesn't exist,
		-- exit the function
		if not extracted_items_cha then return end

		-- If the extracted item is not a directory
		if not extracted_items_cha.is_dir then
			--

			-- Reveal the item and exit the function
			return ya.mgr_emit("reveal", { extracted_items_url })
		end

		-- Otherwise, change the directory to the extracted item.
		-- Note that extracted_items_url is destroyed here.
		ya.mgr_emit("cd", { extracted_items_url })

		-- If the user wants to skip single subdirectories on enter,
		-- and the no skip flag is not passed
		if
			config.skip_single_subdirectory_on_enter
			and not table_pop(args, "no_skip", false)
		then
			--

			-- Call the function to skip child directories
			skip_single_child_directories(extracted_items_path)
		end
	end
end

-- Function to handle the enter command
---@type CommandFunction
local function handle_enter(args, config)
	--

	-- If the hovered item is not a directory
	if not hovered_item_is_dir() then
		--

		-- If smart enter is wanted,
		-- call the function for the open command
		-- and exit the function
		if config.smart_enter or table_pop(args, "smart", false) then
			return emit_plugin_command("open", args)
		end

		-- Otherwise, just exit the function
		return
	end

	-- Otherwise, always emit the enter command,
	ya.mgr_emit("enter", args)

	-- If the user doesn't want to skip single subdirectories on enter,
	-- or one of the arguments passed is no skip,
	-- then exit the function
	if
		not config.skip_single_subdirectory_on_enter
		or table_pop(args, "no_skip", false)
	then
		return
	end

	-- Otherwise, call the function to skip child directories
	-- with only a single directory inside
	skip_single_child_directories(get_current_directory())
end

-- Function to handle the leave command
---@type CommandFunction
local function handle_leave(args, config)
	--

	-- Always emit the leave command
	ya.mgr_emit("leave", args)

	-- If the user doesn't want to skip single subdirectories on leave,
	-- or one of the arguments passed is no skip,
	-- then exit the function
	if
		not config.skip_single_subdirectory_on_leave
		or table_pop(args, "no_skip", false)
	then
		return
	end

	-- Otherwise, initialise the directory to the current directory
	local directory = get_current_directory()

	-- Get the tab preferences
	local tab_preferences = get_tab_preferences()

	-- Start an infinite loop
	while true do
		--

		-- Get all the items in the current directory
		local directory_items =
			get_directory_items(directory, tab_preferences.show_hidden)

		-- If the number of directory items is not 1,
		-- then break out of the loop.
		if #directory_items ~= 1 then break end

		-- Get the parent directory of the current directory
		---@type Url|nil
		local parent_directory = Url(directory):parent()

		-- If the parent directory is nil,
		-- break the loop
		if not parent_directory then break end

		-- Otherwise, set the new directory to the parent directory
		directory = tostring(parent_directory)
	end

	-- Emit the change directory command to change to the directory variable
	ya.mgr_emit("cd", { directory })
end

-- Function to handle a Yazi command
---@param command string A Yazi command
---@param args Arguments The arguments passed to the plugin
---@return nil
local function handle_yazi_command(command, args)
	--

	-- Call the function to get the item group
	local item_group = get_item_group()

	-- If no item group is returned, exit the function
	if not item_group then return end

	-- If the item group is the selected items
	if item_group == ItemGroup.Selected then
		--

		-- Emit the command to operate on the selected items
		ya.mgr_emit(command, args)

	-- If the item group is the hovered item
	elseif item_group == ItemGroup.Hovered then
		--

		-- Emit the command with the hovered option
		ya.mgr_emit(command, merge_tables(args, { hovered = true }))
	end
end

-- Function to enter or open the created file
---@param item_url Url The url of the item to create
---@param is_directory boolean|nil Whether the item to create is a directory
---@param args Arguments The arguments passed to the plugin
---@param config Configuration The configuration object
---@return nil
local function enter_or_open_created_item(item_url, is_directory, args, config)
	--

	-- If the item is a directory
	if is_directory then
		--

		-- If user does not want to enter the directory
		-- after creating it, exit the function
		if
			not (
				config.enter_directory_after_creation
				or table_pop(args, "enter", false)
			)
		then
			return
		end

		-- Otherwise, call the function change to the created directory
		return ya.mgr_emit("cd", { item_url })
	end

	-- Otherwise, the item is a file

	-- If the user does not want to open the file
	-- after creating it, exit the function
	if
		not (config.open_file_after_creation or table_pop(args, "open", false))
	then
		return
	end

	-- Otherwise, call the function to reveal the created file
	ya.mgr_emit("reveal", { item_url })

	-- Wait for Yazi to finish loading
	wait_until_yazi_is_loaded()

	-- Call the function to open the file
	return ya.mgr_emit("open", { hovered = true })
end

-- Function to execute the create command
---@param item_url Url The url of the item to create
---@param args Arguments The arguments passed to the plugin
---@param config Configuration The configuration object
---@return nil
local function execute_create(item_url, is_directory, args, config)
	--

	-- Get the parent directory of the file to create
	local parent_directory_url = item_url:parent()

	-- If the parent directory doesn't exist,
	-- then show an error and exit the function
	if not parent_directory_url then
		return show_error(
			"Parent directory of the item to create doesn't exist"
		)
	end

	-- If the item to create is a directory
	if is_directory then
		--

		-- Call the function to create the directory
		local successful, error_message = fs.create("dir_all", item_url)

		-- If the function is not successful,
		-- show the error message and exit the function
		if not successful then return show_error(error_message) end

	-- Otherwise, the item to create is a file
	else
		--

		-- Otherwise, create the parent directory if it doesn't exist
		if not fs.cha(parent_directory_url, false) then
			--

			-- Call the function to create the parent directory
			local successful, error_message =
				fs.create("dir_all", parent_directory_url)

			-- If the function is not successful,
			-- show the error message and exit the function
			if not successful then return show_error(error_message) end
		end

		-- Otherwise, create the file
		local successful, error_message = fs.write(item_url, "")

		-- If the function is not successful,
		-- show the error message and exit the function
		if not successful then return show_error(error_message) end
	end

	-- Call the function to enter or open the created item
	enter_or_open_created_item(item_url, is_directory, args, config)
end

-- Function to handle the create command
---@type CommandFunction
local function handle_create(args, config)
	--

	-- Get the directory flag
	local dir_flag = table_pop(args, "dir", false)

	-- Get the user's input for the item to create
	local user_input, event =
		get_user_input(dir_flag and "Create (dir):" or "Create:")

	-- If the user input is nil,
	-- or if the user did not confirm the input,
	-- exit the function
	if not user_input or event ~= 1 then return end

	-- Get the current working directory as a url
	---@type Url
	local current_working_directory = Url(get_current_directory())

	-- Get whether the url ends with a path delimiter
	local ends_with_path_delimiter = user_input:find("[/\\]$")

	-- Get the whether the given item is a directory or not based
	-- on the default conditions for a directory
	local is_directory = ends_with_path_delimiter or dir_flag

	-- Get the url from the user's input
	---@type Url
	local item_url = Url(user_input)

	-- If the user does not want to use the default Yazi create behaviour
	if
		not (
			config.use_default_create_behaviour
			or table_pop(args, "default_behaviour", false)
		)
	then
		--

		-- Get the file extension from the user's input
		local file_extension = user_input:match(file_extension_pattern)

		-- Set the is directory variable to the is directory condition
		-- or if the file extension exists
		is_directory = is_directory or not file_extension
	end

	-- Get the full url of the item to create
	local full_url = current_working_directory:join(item_url)

	-- If the path to the item to create already exists,
	-- and the user did not pass the force flag
	if fs.cha(full_url, false) and not table_pop(args, "force", false) then
		--

		-- Get the user's confirmation for
		-- whether they want to overwrite the item
		local user_confirmation = get_user_confirmation(
			"Overwrite file?",
			ui.Text({
				ui.Line("Will overwrite the following file:")
					:align(ui.Line.CENTER),
				ui.Line(string.rep("─", DEFAULT_CONFIRM_OPTIONS.pos.w - 2))
					:style(ui.Style(th.confirm.border))
					:align(ui.Line.LEFT),
				ui.Line(tostring(full_url)):align(ui.Line.LEFT),
			}):wrap(ui.Text.WRAP_TRIM)
		)

		-- If the user did not confirm the overwrite,
		-- then exit the function
		if not user_confirmation then return end
	end

	-- Call the function to execute the create command
	return execute_create(full_url, is_directory, args, config)
end

-- Function to remove the F flag from the less command
---@param command string The shell command containing the less command
---@return string command The command with the F flag removed
---@return boolean f_flag_found Whether the F flag was found
local function remove_f_flag_from_less_command(command)
	--

	-- Initialise the variable to store if the F flag is found
	local f_flag_found = false

	-- Initialise the variable to store the replacement count
	local replacement_count = 0

	-- Remove the F flag when it is passed at the start
	-- of the flags given to the less command
	command, replacement_count = command:gsub("(%f[%a]less%f[%A].*)%-F", "%1")

	-- If the replacement count is not 0,
	-- set the f_flag_found variable to true
	if replacement_count ~= 0 then f_flag_found = true end

	-- Remove the F flag when it is passed in the middle
	-- or end of the flags given to the less command command
	command, replacement_count =
		command:gsub("(%f[%a]less%f[%A].*%-)(%a*)F(%a*)", "%1%2%3")

	-- If the replacement count is not 0,
	-- set the f_flag_found variable to true
	if replacement_count ~= 0 then f_flag_found = true end

	-- Return the command and whether or not the F flag was found
	return command, f_flag_found
end

-- Function to fix a command containing less.
-- All this function does is remove
-- the F flag from a command containing less.
---@param command string The shell command containing the less command
---@return string command The fixed shell command
local function fix_shell_command_containing_less(command)
	--

	-- Remove the F flag from the given command
	local fixed_command = remove_f_flag_from_less_command(command)

	-- Get the LESS environment variable
	local less_environment_variable = os.getenv("LESS")

	-- If the LESS environment variable is not set,
	-- then return the given command with the F flag removed
	if not less_environment_variable then return fixed_command end

	-- Otherwise, remove the F flag from the LESS environment variable
	-- and check if the F flag was found
	local less_command_with_modified_env_variables, f_flag_found =
		remove_f_flag_from_less_command("less " .. less_environment_variable)

	-- If the F flag isn't found,
	-- then return the given command with the F flag removed
	if not f_flag_found then return fixed_command end

	-- Add the less environment variable flags to the less command
	fixed_command = fixed_command:gsub(
		"%f[%a]less%f[%A]",
		escape_replacement_string(less_command_with_modified_env_variables)
	)

	-- Unset the LESS environment variable before calling the command
	fixed_command = "unset LESS; " .. fixed_command

	-- Return the fixed command
	return fixed_command
end

-- Function to fix the bat default pager command
---@param command string The command containing the bat default pager command
---@return string command The fixed bat command
local function fix_shell_command_containing_bat(command)
	--

	-- The pattern to match the pager argument for the bat command
	local bat_pager_pattern = "(%-%-pager)%s+(%S+)"

	-- Get the pager argument for the bat command
	local _, pager_argument = command:match(bat_pager_pattern)

	-- If there is a pager argument
	--
	-- We don't need to do much if the pager argument already exists,
	-- as we can rely on the function that fixes the less command to
	-- remove the -F flag that is executed after this function is called.
	--
	-- There's only work to be done if the pager argument isn't quoted,
	-- as we need to quote it so the function that fixes the less command
	-- can execute cleanly without causing shell syntax errors.
	--
	-- The reason why we don't quote the less command in the function
	-- to fix the less command is to not deal with using backslashes
	-- to escape the quotes, which can get really messy and really confusing,
	-- so we just naively replace the less command with the fixed version
	-- without caring about whether the less command is passed as an
	-- argument, or is called as a shell command.
	if pager_argument then
		--

		-- If the pager argument is quoted, return the command immediately
		if pager_argument:find("['\"].+['\"]") then return command end

		-- Otherwise, quote the pager argument with single quotes
		--
		-- It should be fine to quote with single quotes
		-- as the user passing the argument probably isn't
		-- using a shell variable, as they would have quoted
		-- the shell variable in double quotes instead of
		-- omitting the quotes.
		pager_argument = string.format("'%s'", pager_argument)

		-- Replace the pager argument with the quoted version
		local modified_command =
			command:gsub(bat_pager_pattern, "%1 " .. pager_argument)

		-- Return the modified command
		return modified_command
	end

	-- If there is no pager argument,
	-- initialise the default pager command for bat without the F flag
	local bat_default_pager_command_without_f_flag = "less -RX"

	-- Replace the bat command with the command to use the
	-- bat default pager command without the F flag
	local modified_command = command:gsub(
		bat_command_pattern,
		string.format(
			"bat --pager '%s'",
			bat_default_pager_command_without_f_flag
		),
		1
	)

	-- Return the modified command
	return modified_command
end

-- Function to fix the shell commands given to work properly with Yazi
---@param command string A shell command
---@return string command The fixed shell command
local function fix_shell_command(command)
	--

	-- If the given command contains the bat command
	if command:find(bat_command_pattern) ~= nil then
		--

		-- Calls the command to fix the bat command
		command = fix_shell_command_containing_bat(command)
	end

	-- If the given command includes the less command
	if command:find("%f[%a]less%f[%A]") ~= nil then
		--

		-- Fix the command containing less
		command = fix_shell_command_containing_less(command)
	end

	-- Return the modified command
	return command
end

-- Function to handle a shell command
---@type CommandFunction
local function handle_shell(args, _)
	--

	-- Get the first item of the arguments given
	-- and set it to the command variable
	local command = table.remove(args, 1)

	-- Get the type of the command variable
	local command_type = type(command)

	-- If the command isn't a string,
	-- show an error message and exit the function
	if command_type ~= "string" then
		return show_error(
			string.format(
				"Shell command given is not a string, "
					.. "instead it is a '%s', "
					.. "with value '%s'",
				command_type,
				tostring(command)
			)
		)
	end

	-- Fix the given command
	command = fix_shell_command(command)

	-- Call the function to get the item group
	local item_group = get_item_group()

	-- If no item group is returned, exit the function
	if not item_group then return end

	-- Get whether the exit if directory flag is passed
	local exit_if_dir = table_pop(args, "exit_if_dir", false)

	-- If the item group is the selected items
	if item_group == ItemGroup.Selected then
		--

		-- Get the paths of the selected items
		local selected_items = get_paths_of_selected_items(true)

		-- If there are no selected items, exit the function
		if not selected_items then return end

		-- If the exit if directory flag is passed
		if exit_if_dir then
			--

			-- Initialise the number of files
			local number_of_files = 0

			-- Iterate over all of the selected items
			for _, item in pairs(selected_items) do
				--

				-- Get the cha object of the item
				local item_cha = fs.cha(Url(item), false)

				-- If the item isn't a directory
				if not (item_cha or {}).is_dir then
					--

					-- Increment the number of files
					number_of_files = number_of_files + 1
				end
			end

			-- If the number of files is 0, then exit the function
			if number_of_files == 0 then return end
		end

		-- Replace the shell variable in the command
		-- with the quoted paths of the selected items
		command = command:gsub(
			shell_variable_pattern,
			escape_replacement_string(table.concat(selected_items, " "))
		)

	-- If the item group is the hovered item
	elseif item_group == ItemGroup.Hovered then
		--

		-- Get the hovered item path
		local hovered_item_path = get_path_of_hovered_item(true)

		-- If the hovered item path is nil, exit the function
		if not hovered_item_path then return end

		-- If the exit if directory flag is passed,
		-- and the hovered item is a directory,
		-- then exit the function
		if exit_if_dir and hovered_item_is_dir() then return end

		-- Replace the shell variable in the command
		-- with the quoted path of the hovered item
		command = command:gsub(
			shell_variable_pattern,
			escape_replacement_string(hovered_item_path)
		)

	-- Otherwise, exit the function
	else
		return
	end

	-- Merge the command back into the arguments given
	args = merge_tables({ command }, args)

	-- Emit the command to operate on the hovered item
	ya.mgr_emit("shell", args)
end

-- Function to handle the paste command
---@type CommandFunction
local function handle_paste(args, config)
	--

	-- If the hovered item is not a directory or smart paste is not wanted
	if
		not hovered_item_is_dir()
		or not (config.smart_paste or table_pop(args, "smart", false))
	then
		--

		-- Just paste the items inside the current directory
		-- and exit the function
		return ya.mgr_emit("paste", args)
	end

	-- Otherwise, enter the directory
	ya.mgr_emit("enter", {})

	-- Paste the items inside the directory
	ya.mgr_emit("paste", args)

	-- Leave the directory
	ya.mgr_emit("leave", {})
end

-- Function to execute the tab create command
---@type fun(
---	args: Arguments,    -- The arguments passed to the plugin
---): nil
local execute_tab_create = ya.sync(function(state, args)
	--

	-- Get the hovered item
	local hovered_item = cx.active.current.hovered

	-- If the hovered item is nil,
	-- or if the hovered item is not a directory,
	-- or if the user doesn't want to smartly
	-- create a tab in the hovered directory
	if
		not hovered_item
		or not hovered_item.cha.is_dir
		or not (
			state.config.smart_tab_create or table_pop(args, "smart", false)
		)
	then
		--

		-- Emit the command to create a new tab with the arguments
		-- and exit the function
		return ya.mgr_emit("tab_create", args)
	end

	-- Otherwise, emit the command to create a new tab
	-- with the hovered item's url
	ya.mgr_emit("tab_create", { hovered_item.url })
end)

-- Function to handle the tab create command
---@type CommandFunction
local function handle_tab_create(args)
	--

	-- Call the function to execute the tab create command
	execute_tab_create(args)
end

-- Function to execute the tab switch command
---@type fun(
---	args: Arguments,    -- The arguments passed to the plugin
---): nil
local execute_tab_switch = ya.sync(function(state, args)
	--

	-- Get the tab index
	local tab_index = args[1]

	-- If no tab index is given, exit the function
	if not tab_index then return end

	-- If the user doesn't want to create tabs
	-- when switching to a new tab,
	-- or the tab index is not given,
	-- then just call the tab switch command
	-- and exit the function
	if
		not (state.config.smart_tab_switch or table_pop(args, "smart", false))
	then
		return ya.mgr_emit("tab_switch", args)
	end

	-- Get the current tab
	local current_tab = cx.active.current

	-- Get the number of tabs currently open
	local number_of_open_tabs = #cx.tabs

	-- Iterate from the number of current open tabs
	-- to the given tab number
	for _ = number_of_open_tabs, tab_index do
		--

		-- Call the tab create command
		ya.mgr_emit("tab_create", { current_tab.cwd })

		-- If there is a hovered item
		if current_tab.hovered then
			--

			-- Reveal the hovered item
			ya.mgr_emit("reveal", { current_tab.hovered.url })
		end
	end

	-- Switch to the given tab index
	ya.mgr_emit("tab_switch", args)
end)

-- Function to handle the tab switch command
---@type CommandFunction
local function handle_tab_switch(args)
	--

	-- Call the function to execute the tab switch command
	execute_tab_switch(args)
end

-- Function to execute the quit command
---@type CommandFunction
local function handle_quit(args, config)
	--

	-- Get the number of tabs
	local number_of_tabs = get_number_of_tabs()

	-- If the user doesn't want the confirm on quit functionality,
	-- or if the number of tabs is 1 or less,
	-- then emit the quit command
	if not (config.confirm_on_quit or args.confirm) or number_of_tabs <= 1 then
		return ya.mgr_emit("quit", args)
	end

	-- Otherwise, get the user's confirmation for quitting
	local user_confirmation = get_user_confirmation(
		"Quit?",
		ui.Text({
			"There are multiple tabs open.",
			"Are you sure you want to quit?",
		}):wrap(ui.Text.WRAP_TRIM)
	)

	-- If the user didn't confirm, then exit the function
	if not user_confirmation then return end

	-- Otherwise, emit the quit command
	ya.mgr_emit("quit", args)
end

-- Function to handle smooth scrolling
---@param steps number The number of steps to scroll
---@param scroll_delay number The scroll delay in seconds
---@param scroll_func fun(step: integer): nil The function to call to scroll
local function smoothly_scroll(steps, scroll_delay, scroll_func)
	--

	-- Initialise the direction to positive 1
	local direction = 1

	-- If the number of steps is negative
	if steps < 0 then
		--

		-- Set the direction to negative 1
		direction = -1

		-- Convert the number of steps to positive
		steps = -steps
	end

	-- Iterate over the number of steps
	for _ = 1, steps do
		--

		-- Call the function to scroll
		scroll_func(direction)

		-- Pause for the scroll delay
		ya.sleep(scroll_delay)
	end
end

-- [TODO]: Make use of the arrow prev and arrow next commands
-- once stabilised.
-- PR: https://github.com/sxyazi/yazi/pull/2485
-- Docs: https://yazi-rs.github.io/docs/configuration/keymap/#manager.arrow
--
-- Function to do the wraparound for the arrow command
---@type fun(
---	args: Arguments,    -- The arguments passed to the plugin
---): nil
local wraparound_arrow = ya.sync(function(_, args)
	--

	-- Get the current tab
	local current_tab = cx.active.current

	-- Get the number of steps from the arguments given
	local steps = table.remove(args, 1) or 1

	-- If the step isn't a number,
	-- immediately emit the arrow command
	-- and exit the function
	if type(steps) ~= "number" then
		return ya.mgr_emit("arrow", merge_tables(args, { steps }))
	end

	-- Get the number of files in the current tab
	local number_of_files = #current_tab.files

	-- If there are no files in the current tab, exit the function
	if number_of_files == 0 then return end

	-- Get the new cursor index,
	-- which is the current cursor position plus the step given
	-- to the arrow function, modulus the number of files in
	-- the current tab
	local new_cursor_index = (current_tab.cursor + steps) % number_of_files

	-- Get the url of the item at the new cursor index.
	--
	-- The plus one is needed to convert the cursor index,
	-- which is 0-based, to a 1-based index,
	-- which is what is used to index into the list of files.
	local item_url = current_tab.files[new_cursor_index + 1].url

	-- Emit the reveal command
	ya.mgr_emit("reveal", merge_tables(args, { item_url }))
end)

-- Function to handle the arrow command
---@type CommandFunction
local function handle_arrow(args, config)
	--

	-- If smooth scrolling is wanted,
	if config.smooth_scrolling then
		--

		-- Get the number of steps from the arguments given
		local steps = table.remove(args, 1) or 1

		-- If the number of steps isn't a number,
		-- immediately emit the arrow command
		-- and exit the function
		if type(steps) ~= "number" then
			return ya.mgr_emit("arrow", merge_tables(args, { steps }))
		end

		-- Initialise the function to the regular arrow command
		local function scroll_func(step)
			ya.mgr_emit("arrow", merge_tables(args, { step }))
		end

		-- If wraparound file navigation is wanted
		if config.wraparound_file_navigation then
			--

			-- Set the scroll function to the wraparound arrow command
			function scroll_func(step)
				wraparound_arrow(merge_tables(args, { step }))
			end
		end

		-- Call the smoothly scroll function and exit the function
		return smoothly_scroll(steps, config.scroll_delay, scroll_func)
	end

	-- Otherwise, if smooth scrolling is not wanted,
	-- and wraparound file navigation is wanted,
	-- call the wraparound arrow function
	-- and exit the function
	if config.wraparound_file_navigation then return wraparound_arrow(args) end

	-- Otherwise, emit the regular arrow command
	ya.mgr_emit("arrow", args)
end

-- Function to get the directory items in the parent directory
---@type fun(
---	directories_only: boolean,    -- Whether to only get directories
---): string[] directory_items The list of paths to the directory items
local get_parent_directory_items = ya.sync(function(_, directories_only)
	--

	-- Initialise the list of directory items
	local directory_items = {}

	-- Get the parent directory
	local parent_directory = cx.active.parent

	-- If the parent directory doesn't exist,
	-- return the empty list of directory items
	if not parent_directory then return directory_items end

	-- Otherwise, iterate over the items in the parent directory
	for _, item in ipairs(parent_directory.files) do
		--

		-- If the directories only flag is passed,
		-- and the item is not a directory,
		-- then skip the item
		if directories_only and not item.cha.is_dir then goto continue end

		-- Otherwise, add the item to the list of directory items
		table.insert(directory_items, item)

		-- The continue label to skip the item
		::continue::
	end

	-- Return the list of directory items
	return directory_items
end)

-- Function to execute the parent arrow command
---@type fun(
---	args: Arguments,    -- The arguments passed to the plugin
---): nil
local execute_parent_arrow = ya.sync(function(state, args)
	--

	-- Gets the parent directory
	local parent_directory = cx.active.parent

	-- If the parent directory doesn't exist,
	-- then exit the function
	if not parent_directory then return end

	-- Get the offset from the arguments given
	local offset = table.remove(args, 1) or 1

	-- Get the type of the offset
	local offset_type = type(offset)

	-- If the offset is not a number,
	-- then show an error that the offset is not a number
	-- and exit the function
	if offset_type ~= "number" then
		return show_error(
			string.format(
				"The given offset is not of the type 'number', "
					.. "instead it is a '%s', "
					.. "with value '%s'",
				offset_type,
				tostring(offset)
			)
		)
	end

	-- Get the number of items in the parent directory
	local number_of_items = #parent_directory.files

	-- Initialise the new cursor index
	-- to the current cursor index
	local new_cursor_index = parent_directory.cursor

	-- Get whether the user wants to sort directories first
	local sort_directories_first = cx.active.pref.sort_dir_first

	-- If wraparound file navigation is wanted
	if state.config.wraparound_file_navigation then
		--

		-- If the user sorts their directories first
		if sort_directories_first then
			--

			-- Get the directories in the parent directory
			local directories = get_parent_directory_items(true)

			-- Get the number of directories in the parent directory
			local number_of_directories = #directories

			-- If the number of directories is 0, then exit the function
			if number_of_directories == 0 then return end

			-- Get the new cursor index by adding the offset,
			-- and modding the whole thing by the number of directories
			new_cursor_index = (parent_directory.cursor + offset)
				% number_of_directories

		-- Otherwise, if the user doesn't sort their directories first
		else
			--

			-- Get the new cursor index by adding the offset,
			-- and modding the whole thing by the number of
			-- items in the parent directory
			new_cursor_index = (parent_directory.cursor + offset)
				% number_of_items
		end

	-- Otherwise, get the new cursor index normally
	-- by adding the offset to the cursor index
	else
		new_cursor_index = parent_directory.cursor + offset
	end

	-- Increment the cursor index by 1.
	-- The cursor index needs to be increased by 1
	-- as the cursor index is 0-based, while Lua
	-- tables are 1-based.
	new_cursor_index = new_cursor_index + 1

	-- Get the starting index of the loop
	local start_index = new_cursor_index

	-- Get the ending index of the loop.
	--
	-- If the offset given is negative, set the end index to 1,
	-- as the loop will iterate backwards.
	-- Otherwise, if the step given is positive,
	-- set the end index to the number of items in the
	-- parent directory.
	local end_index = offset < 0 and 1 or number_of_items

	-- Get the step for the loop.
	--
	-- If the offset given is negative, set the step to -1,
	-- as the loop will iterate backwards.
	-- Otherwise, if the step given is positive, set
	-- the step to 1 to iterate forwards.
	local step = offset < 0 and -1 or 1

	-- Iterate over the parent directory items
	for i = start_index, end_index, step do
		--

		-- Get the directory item
		local directory_item = parent_directory.files[i]

		-- If the directory item exists and is a directory
		if directory_item and directory_item.cha.is_dir then
			--

			-- Emit the command to change directory to
			-- the directory item and exit the function
			return ya.mgr_emit("cd", { directory_item.url })
		end
	end
end)

-- Function to handle the parent arrow command
---@type CommandFunction
local function handle_parent_arrow(args, config)
	--

	-- If smooth scrolling is not wanted,
	-- call the function to execute the parent arrow command
	if not config.smooth_scrolling then execute_parent_arrow(args) end

	-- Otherwise, smooth scrolling is wanted,
	-- so get the number of steps from the arguments given
	local steps = table.remove(args, 1) or 1

	-- Call the function to smoothly scroll the parent arrow command
	smoothly_scroll(
		steps,
		config.scroll_delay,
		function(step) execute_parent_arrow(merge_tables(args, { step })) end
	)
end

-- Function to handle the editor command
---@type CommandFunction
local function handle_editor(args, config)
	--

	-- Get the editor environment variable
	local editor = os.getenv("EDITOR")

	-- If the editor not set, exit the function
	if not editor then return end

	-- Call the handle shell function
	-- with the editor command
	handle_shell(
		merge_tables({
			editor .. " $@",
			block = true,
			exit_if_dir = true,
		}, args),
		config
	)
end

-- Function to handle the pager command
---@type CommandFunction
local function handle_pager(args, config)
	--

	-- Get the pager environment variable
	local pager = os.getenv("PAGER")

	-- If the pager is not set, exit the function
	if not pager then return end

	-- Call the handle shell function
	-- with the pager command
	handle_shell(
		merge_tables({
			pager .. " $@",
			block = true,
			exit_if_dir = true,
		}, args),
		config
	)
end

-- Function to run the commands given
---@param command string The command passed to the plugin
---@param args Arguments The arguments passed to the plugin
---@param config Configuration The configuration object
---@return nil
local function run_command_func(command, args, config)
	--

	-- The command table
	---@type CommandTable
	local command_table = {
		[Commands.Open] = handle_open,
		[Commands.Extract] = handle_extract,
		[Commands.Enter] = handle_enter,
		[Commands.Leave] = handle_leave,
		[Commands.Rename] = function(_) handle_yazi_command("rename", args) end,
		[Commands.Remove] = function(_) handle_yazi_command("remove", args) end,
		[Commands.Create] = handle_create,
		[Commands.Shell] = handle_shell,
		[Commands.Paste] = handle_paste,
		[Commands.TabCreate] = handle_tab_create,
		[Commands.TabSwitch] = handle_tab_switch,
		[Commands.Quit] = handle_quit,
		[Commands.Arrow] = handle_arrow,
		[Commands.ParentArrow] = handle_parent_arrow,
		[Commands.Editor] = handle_editor,
		[Commands.Pager] = handle_pager,
	}

	-- Get the function for the command
	---@type CommandFunction|nil
	local command_func = command_table[command]

	-- If the function isn't found, notify the user and exit the function
	if not command_func then
		return show_error("Unknown command: " .. command)
	end

	-- Otherwise, call the function for the command
	command_func(args, config)
end

-- The setup function to setup the plugin
---@param _ any
---@param opts Configuration|nil The options given to the plugin
---@return nil
local function setup(_, opts)
	--

	-- Initialise the plugin
	initialise_plugin(opts)
end

-- Function to be called to use the plugin
---@param _ any
---@param job { args: Arguments } The job object given by Yazi
---@return nil
local function entry(_, job)
	--

	-- Get the arguments to the plugin
	---@type Arguments
	local args = parse_number_arguments(job.args)

	-- Get the command passed to the plugin
	local command = table.remove(args, 1)

	-- If the command isn't given, exit the function
	if not command then return end

	-- Get the configuration object
	local config = get_config()

	-- If the configuration hasn't been initialised yet,
	-- then initialise the plugin with the default configuration,
	-- as it hasn't been initialised either
	if not config then config = initialise_plugin() end

	-- Call the function to handle the commands
	run_command_func(command, args, config)
end

-- Returns the table required for Yazi to run the plugin
---@return { setup: fun(): nil, entry: fun(): nil }
return {
	setup = setup,
	entry = entry,
}
