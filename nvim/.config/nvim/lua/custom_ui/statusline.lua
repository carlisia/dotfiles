local M = {}

local completion = require "utils.completion"
local format = require "utils.format"
local inlay = require "utils.inlay"

-- Ensure `stbufnr()` always returns a valid buffer
local function stbufnr()
  -- Ensure `vim.g.statusline_winid` is valid
  local winid = vim.g.statusline_winid
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    winid = vim.api.nvim_get_current_win() -- Fallback to current window
  end

  return vim.api.nvim_win_get_buf(winid)
end

M.cmp_ui = {
  lspkind_text = true,
  icons = true,
  icons_left = false,
  style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
  format_colors = {
    tailwind = true,
  },
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

      local sep_left = ""
      local sep_right = ""

      local m = vim.api.nvim_get_mode().mode
      return "%#St_"
        .. modes[m][2]
        .. "Mode#"
        .. (modes[m][3] or "  ")
        .. modes[m][1]
        .. "               "
        .. "%#St_pos_sep#"
        .. sep_right
    end,

    relative_path = function()
      local path = vim.api.nvim_buf_get_name(stbufnr())
      if path == "" then
        return ""
      end

      local clean_path = vim.fn.expand "%:.:h"

      -- Remove leading dot if present
      if clean_path:sub(1, 1) == "." then
        clean_path = clean_path:sub(2)
      end

      return "%#St_relativepath# " .. clean_path .. " "
    end,

    icon_filename = function()
      -- Adapted from:
      -- https://github.com/BrunoKrugel/dotfiles/blob/6eb51723ef63ebde3701ee48d1397ee91edb62a9/lua/custom/utils/core.lua#L349
      local icon = " 󰈚 "
      local filename = vim.fn.expand "%:t"
      local icon_text

      if filename ~= "Empty " then
        local devicons_present, devicons = pcall(require, "nvim-web-devicons")

        if devicons_present then
          local ft_icon, ft_icon_hl = devicons.get_icon(filename, string.match(filename, "%a+$"))
          icon = (ft_icon ~= nil and " " .. ft_icon) or ""
          local icon_hl = ft_icon_hl or "DevIconDefault"
          local hl_fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(icon_hl)), "fg")
          local hl_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "StText"), "bg")
          vim.api.nvim_set_hl(0, "St_" .. icon_hl, { fg = hl_fg, bg = hl_bg })

          if string.find(filename, "toggleterm") then
            filename = '%{&ft == "toggleterm" ? " Terminal (".b:toggle_number.") " : ""}'
          end
          if string.find(filename, "NvimTree") then
            filename = '%{&ft == "NvimTree" ? " File Explorer " : ""}'
          end

          icon_text = "%#St_" .. icon_hl .. "#" .. icon .. "%#StText# " .. filename .. " "
        end
      end

      return icon_text or ("%#StText# " .. icon .. filename)
    end,

    git_changed = function()
      if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status or vim.o.columns < 120 then
        return ""
      end

      local git_status = vim.b[stbufnr()].gitsigns_status_dict

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
      local breakpoint = 100
      if vim.o.columns < breakpoint then
        return ""
      end

      local ft = vim.bo[stbufnr()].ft
      return ft == " " and " %#St_ft# plain text  " or " %#St_ft#" .. ft .. " "
    end,

    auto_complete = function()
      return " %#St_lspError#" .. completion.current_state_emoji()
    end,

    format_on_save = function()
      return " %#St_lspError#" .. format.current_state_emoji()
    end,

    inlay_enabled = function()
      return " %#St_lspError#" .. inlay.current_state_emoji() .. " | "
    end,
  },
}

return M
