local M = {}

M.current_backlink_count = 0

M.show_obsidian_backlinks = function()
  vim.cmd "ObsidianBacklinks"
end

-- Called from enter_note callback
M.set_backlink_count = function(client, note)
  if not client or not note then
    M.current_backlink_count = 0
    return
  end

  local ok, backlinks = pcall(function()
    return client:find_backlinks(note)
  end)

  if ok and backlinks then
    M.current_backlink_count = #backlinks
  else
    M.current_backlink_count = 0
  end
end

M.get_backlink_count = function()
  return M.current_backlink_count
end

-- MiniFiles split mapping
M.map_split = function(buf_id, lhs, direction)
  local ok, MiniFiles = pcall(require, "mini.files")
  if not ok then
    return
  end

  local rhs = function()
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target)
  end

  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = "Split " .. direction })
end

-- Image handling
local assets_subdir = "/assets"

local function find_project_root()
  local path = vim.fn.expand "%:p"
  while path and path ~= "/" do
    if vim.fn.isdirectory(path .. "/.git") == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return vim.fn.getcwd()
end

M.rename_image_under_cursor = function()
  local Snacks = _G.Snacks or require "snacks"

  local function get_image_path()
    local line = vim.api.nvim_get_current_line()
    local image_pattern = "%[.-%]%((.-)%)"
    local _, _, image_path = string.find(line, image_pattern)
    return image_path
  end

  local image_path = get_image_path()
  if not image_path then
    vim.notify("No image found under the cursor", vim.log.levels.WARN)
    return
  end

  if image_path:match "^https?://" then
    vim.notify("Cannot rename remote image URLs", vim.log.levels.WARN)
    return
  end

  local current_file_dir = vim.fn.expand "%:p:h"
  local absolute_image_path = vim.fs.normalize(current_file_dir .. "/" .. image_path)

  if vim.fn.filereadable(absolute_image_path) == 0 then
    vim.notify("Image file does not exist: " .. absolute_image_path, vim.log.levels.ERROR)
    return
  end

  local ext = vim.fn.fnamemodify(absolute_image_path, ":e")
  local current_name = vim.fn.fnamemodify(absolute_image_path, ":t:r")
  local dir = vim.fn.fnamemodify(absolute_image_path, ":h")

  Snacks.input({
    win = {
      position = "float",
      relative = "cursor",
      row = 1,
      col = 0,
      border = "rounded",
      width = 40,
    },
    prompt = "New image name (no extension):",
    default = current_name,
  }, function(new_name)
    if not new_name or new_name == "" or new_name == current_name then
      vim.notify("Rename cancelled", vim.log.levels.INFO)
      return
    end

    local new_absolute_path = dir .. "/" .. new_name .. "." .. ext
    if vim.fn.filereadable(new_absolute_path) == 1 then
      vim.notify("File already exists: " .. new_absolute_path, vim.log.levels.ERROR)
      return
    end

    local ok, err = os.rename(absolute_image_path, new_absolute_path)
    if not ok then
      vim.notify("Failed to rename image: " .. err, vim.log.levels.ERROR)
      return
    end

    local new_filename = new_name .. "." .. ext

    -- Replace markdown image references (alt and filename)
    local total_lines = vim.api.nvim_buf_line_count(0)
    for i = 0, total_lines - 1 do
      local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
      for alt, path in line:gmatch "!%[(.-)%]%((.-)%)" do
        if path == image_path then
          local path_prefix = path:match ".*/" or ""
          local old_markdown = "![" .. alt .. "](" .. path .. ")"
          local new_markdown = "![" .. new_name .. "](" .. path_prefix .. new_filename .. ")"
          local updated = line:gsub(vim.pesc(old_markdown), new_markdown)
          vim.api.nvim_buf_set_lines(0, i, i + 1, false, { updated })
        end
      end
    end

    -- Highlight the new filename
    local ns = vim.api.nvim_create_namespace "RenameHighlight"
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local col_start, col_end = vim.api.nvim_get_current_line():find(new_filename, 1, true)
    if col_start and col_end then
      vim.highlight.range(0, ns, "IncSearch", { row, col_start - 1 }, { row, col_end }, { inclusive = true })
      vim.defer_fn(function()
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      end, 1000)
    end

    vim.cmd "update"
    vim.notify("Renamed image, alt text, and updated references", vim.log.levels.INFO)
  end)
end

M.delete_image_under_cursor = function()
  local function get_image_path()
    local line = vim.api.nvim_get_current_line()
    local image_pattern = "%[.-%]%((.-)%)"
    local _, _, image_path = string.find(line, image_pattern)
    return image_path
  end

  local image_path = get_image_path()
  if not image_path then
    vim.notify("No image found under the cursor", vim.log.levels.WARN)
    return
  end

  if image_path:match "^https?://" then
    vim.notify("Cannot delete remote image URLs", vim.log.levels.WARN)
    return
  end

  local current_file_dir = vim.fn.expand "%:p:h"
  local absolute_image_path = vim.fs.normalize(current_file_dir .. "/" .. image_path)

  if vim.fn.filereadable(absolute_image_path) == 0 then
    vim.notify("Image file does not exist: " .. absolute_image_path, vim.log.levels.ERROR)
    return
  end

  local project_root = find_project_root()
  local project_relative_path = absolute_image_path:sub(#project_root + 2)

  vim.ui.select({ "No", "Yes" }, {
    prompt = "Deleting file:\n" .. project_relative_path .. "\n\n- Are you sure?",
  }, function(choice)
    if choice ~= "Yes" then
      vim.notify("Deletion cancelled", vim.log.levels.INFO)
      return
    end

    local ok, err = os.remove(absolute_image_path)
    if not ok then
      vim.notify("Failed to delete file: " .. err, vim.log.levels.ERROR)
      return
    end

    vim.notify("Deleted file: " .. project_relative_path, vim.log.levels.INFO)

    -- Remove reference from line
    local line = vim.api.nvim_get_current_line()
    local updated_line = line:gsub(vim.pesc(image_path), "", 1)
    vim.api.nvim_set_current_line(updated_line)
  end)
end

M.select_image = function()
  local ok, img_clip = pcall(require, "img-clip")
  if not ok then
    vim.notify("img-clip not found", vim.log.levels.ERROR)
    return
  end

  local project_root = find_project_root()
  local assets_dir = project_root .. assets_subdir
  local files = vim.fn.glob(assets_dir .. "/*.{jpg,jpeg,png,webp}", false, true)

  local items = vim.tbl_map(function(path)
    local filename = vim.fn.fnamemodify(path, ":t")
    return {
      path = path,
      display = filename,
      relative_path = "." .. assets_subdir .. "/" .. filename,
    }
  end, files)

  if vim.tbl_isempty(items) then
    vim.notify("📁 No images found in assets. Try pasting or adding one first.", vim.log.levels.INFO)
    return
  end

  local Snacks = _G.Snacks or require "snacks"
  if not Snacks then
    vim.notify("Snacks not found", vim.log.levels.ERROR)
    return
  end

  Snacks.picker {
    title = "🖼️ Select Image from Assets",
    items = items,
    format = function(item)
      return {
        { item.display, "SnacksPickerLabel" },
        { " | " .. item.relative_path, "SnacksPickerComment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      img_clip.paste_image({ use_absolute_path = false, file_name = item.display }, item.relative_path)
    end,
  }
end

return M
