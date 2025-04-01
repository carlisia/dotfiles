local M = {}

M.config = {
  cmdline = {
    enabled = true, -- enables the Noice cmdline UI
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
  },
  messages = {
    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
    -- This is a current Neovim limitation.
    enabled = true, -- enables the Noice messages UI
    view = "notify", -- default view for messages
    view_error = false, -- view for errors
    view_warn = false, -- view for warnings
    view_history = "messages", -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  notify = { enabled = false },
  notifier = {
    top_down = false,
  },
  presets = {
    command_palette = {
      views = {
        cmdline_popup = {
          position = {
            row = "40%",
            col = "50%",
          },
        },
        cmdline_popupmenu = {
          position = {
            row = "40%",
            col = "50%",
          },
        },
      },
    },
  },
  lsp = {
    progress = {
      enabled = true,
      -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
      -- See the section on formatting for more details on how to customize.
      -- - @type NoiceFormat|string
      format = "lsp_progress",
      -- - @type NoiceFormat|string
      format_done = "lsp_progress_done",
      throttle = 1000 / 30, -- frequency to update lsp progress message
      view = "mini",
    },
    override = {
      -- override the default lsp markdown formatter with Noice
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      -- override the lsp markdown formatter with Noice
      ["vim.lsp.util.stylize_markdown"] = true,
      -- override cmp documentation with Noice (needs the other options to work)
      ["cmp.entry.get_documentation"] = true,
    },
    signature = { enabled = false },
    hover = { enabled = false },
    message = {
      -- Messages shown by lsp servers
      enabled = false,
    },
  },
}

return M
