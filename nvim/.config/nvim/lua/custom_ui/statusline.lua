local M = {}
local toggles = require "utils.toggles"

-- Ensure `stbufnr()` always returns a valid buffer
local function stbufnr()
  local winid = vim.g.statusline_winid
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    winid = vim.api.nvim_get_current_win()
  end

  if not vim.api.nvim_win_is_valid(winid) then
    return 0
  end

  local bufnr = vim.api.nvim_win_get_buf(winid)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return 0
  end

  return bufnr
end

M.cmp_ui = {
  icons_left = true, -- only for non-atom styles
  style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  abbr_maxwidth = 60,
}

M.statusline = {
  theme = "default",
  order = {
    "modes",
    "relative_path",
    "icon_filename",
    "git_changed",
    "diagnostics",
    "%=",
    "auto_complete",
    "format_on_save",
    "inlay_enabled",
    "filetype",
    "backlinks",
    "lsp_msg",
    "%=",
    "lsp",
    "cursor",
    "cwd",
  },
  modules = {
    modes = function()
      local utils = require "nvchad.stl.utils"
      if not utils.is_activewin() then
        return ""
      end
      local modes = utils.modes

      modes["n"][3] = " 😎 "
      modes["v"][3] = " 👁 "
      modes["i"][3] = " ✍️  "
      modes["t"][3] = "  "

      local m = vim.api.nvim_get_mode().mode
      return "%#St_"
        .. modes[m][2]
        .. "Mode#"
        .. (modes[m][3] or "  ")
        .. modes[m][1]
        .. "               "
        .. "%#St_pos_sep#"
    end,

    relative_path = function()
      local path = vim.api.nvim_buf_get_name(stbufnr())
      if path == "" then
        return ""
      end

      local clean_path = vim.fn.expand "%:.:h"
      if clean_path:sub(1, 1) == "." then
        clean_path = clean_path:sub(2)
      end

      return "%#St_relativepath# " .. clean_path .. " "
    end,

    icon_filename = function()
      local icon = " 󰈚 "
      local filename = vim.fn.expand "%:t"
      local icon_text

      if filename ~= "" then
        local devicons_present, devicons = pcall(require, "nvim-web-devicons")

        if devicons_present then
          local ext = vim.fn.fnamemodify(filename, ":e")
          local ft_icon, ft_icon_hl = devicons.get_icon(filename, ext)
          icon = ft_icon and " " .. ft_icon or icon
          local icon_hl = ft_icon_hl or "DevIconDefault"
          local hl_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(icon_hl)), "fg")
          local hl_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "StText"), "bg")
          vim.api.nvim_set_hl(0, "St_" .. icon_hl, { fg = hl_fg, bg = hl_bg })

          if filename:find "toggleterm" then
            filename = '%{&ft == "toggleterm" ? " Terminal (".b:toggle_number.") " : ""}'
          elseif filename:find "NvimTree" then
            filename = '%{&ft == "NvimTree" ? " File Explorer " : ""}'
          end

          icon_text = "%#St_" .. icon_hl .. "#" .. icon .. "%#StText# " .. filename .. " "
        end
      end

      return icon_text or ("%#StText# " .. icon .. filename)
    end,

    git_changed = function()
      local bufnr = stbufnr()
      local git_head = vim.b[bufnr].gitsigns_head
      local git_status = vim.b[bufnr].gitsigns_status_dict

      if not git_head or not git_status or vim.o.columns < 120 then
        return ""
      end

      local added = (git_status.added and git_status.added ~= 0) and ("%#St_lspInfo#  " .. git_status.added .. " ")
        or ""
      local changed = (git_status.changed and git_status.changed ~= 0)
          and ("%#St_lspWarning#  " .. git_status.changed .. " ")
        or ""
      local removed = (git_status.removed and git_status.removed ~= 0)
          and ("%#St_lspError#  " .. git_status.removed .. " ")
        or ""

      return (added .. changed .. removed) ~= "" and (added .. changed .. removed .. " | ") or " "
    end,

    filetype = function()
      if vim.o.columns < 100 then
        return ""
      end

      local bufnr = stbufnr()
      local ft = vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype or ""
      return ft == "" and " %#St_ft# plain text  " or " %#St_ft#" .. ft .. " "
    end,

    auto_complete = function()
      return " %#St_lspError#" .. toggles.completion_emoji()
    end,

    format_on_save = function()
      return " %#St_lspError#" .. toggles.autoformat_on_save_emoji()
    end,

    inlay_enabled = function()
      return " %#St_lspError#" .. toggles.inlay_emoji() .. " | "
    end,

    backlinks = function()
      local count = require("utils.functions").get_backlink_count()
      if count == 0 then
        return ""
      end

      return "%@v:lua.require'utils.functions'.show_obsidian_backlinks@"
        .. "%#St_lspError#"
        .. "📎 "
        .. tostring(count)
        .. " backlinks"
    end,
  },
}

return M
