local M = {}

local completion = require "utils.completion"

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

M.cmpUI = {
  lspkind_text = true,
  icons_left = false,
  style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
  format_colors = {
    tailwind = false,
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
    "notification",
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

      return "%#St_relativepath# " .. vim.fn.expand "%:.:h" .. " 🌱"
    end,

    icon_filename = function()
      local icon_text
      local filename = vim.fn.expand "%:t"

      return icon_text or ("%#StText# " .. filename)
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

    notification = function()
      return " %#St_lspError#" .. completion.toggle_cmp()
    end,
  },
}

return M
