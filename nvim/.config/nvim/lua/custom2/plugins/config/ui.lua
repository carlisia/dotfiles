local M = {}

M.trld = function()
  local present, trld = pcall(require, "trld")

  if not present then
    return
  end

  trld.setup({
    -- where to render the diagnostics. 'top' | 'bottom'
    position = "top",

    -- if this plugin should execute it's builtin auto commands
    auto_cmds = true,

    -- diagnostics highlight group names
    highlights = {
      error = "DiagnosticFloatingError",
      warn = "DiagnosticFloatingWarn",
      info = "DiagnosticFloatingInfo",
      hint = "DiagnosticFloatingHint",
    },
    formatter = function(diag)
      local u = require("trld.utils")
      local diag_lines = {}

      for line in diag.message:gmatch("[^\n]+") do
        line = line:gsub("[ \t]+%f[\r\n%z]", "")
        table.insert(diag_lines, line)
      end

      local lines = {}
      for _, diag_line in ipairs(diag_lines) do
        table.insert(lines, { { diag_line .. " ", u.get_hl_by_serverity(diag.severity) } })
      end

      return lines
    end,
  })
end

M.notify = function()
  local present, notify = pcall(require, "notify")

  if not present then
    vim.notify("notify not found.")
    return
  end

  pcall(function()
    require("telescope").load_extension("notify")
  end)

  notify.setup({
    background_colour = "#121212",
    fps = 60,
    -- stages = "fades",
  })
  vim.api.nvim_set_keymap("n", "q", "", { callback = notify.dismiss })

  --TODO: is here the best place for this?
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
    notify({ result.message }, lvl, {
      title = "LSP | " .. client.name,
      timeout = 10000,
      keep = function()
        return lvl == "ERROR" or lvl == "WARN"
      end,
    })
  end
  vim.notify = require("notify")
end

M.shade = function()
  local present, shade = pcall(require, "shade")

  if not present then
    return
  end

  shade.setup({
    overlay_opacity = 50,
    opacity_step = 1,
    exclude_filetypes = { "NvimTree" },
  })
end

M.autosave = function()
  local present, autosave = pcall(require, "autosave")

  if not present then
    return
  end

  autosave.setup()
end

M.lspsaga = function()
  local present, lspsaga = pcall(require, "lspsaga")

  if not present then
    return
  end

  lspsaga.init_lsp_saga({ max_preview_lines = 50 })
end

M.lsp_signature = function()
  require("lsp_signature").setup({
    bind = false,
    handler_opts = {
      border = "rounded",
    },
    max_width = 80,
    max_height = 4,
    -- doc_lines = 4,
    floating_window = true,

    floating_window_above_cur_line = true,
    fix_pos = false,
    always_trigger = false,
    zindex = 40,
    timer_interval = 100,
  })
end

return M
