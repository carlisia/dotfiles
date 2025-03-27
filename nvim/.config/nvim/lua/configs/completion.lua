local M = {}

local cmp = require "cmp"
M.config = function()
  -- Setup vim-dadbod
  cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    },
  })

  -- `/` cmdline setup.
  cmp.setup.cmdline("/", {
    completion = { completeopt = "menu,menuone,noselect" },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = "" -- remove kind text
        return vim_item
      end,
    },

    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- `:` cmdline setup.
  cmp.setup.cmdline(":", {
    completion = { completeopt = "menu,menuone,noselect" },
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = "" -- remove kind text
        -- vim_item.menu = "" -- remove menu
        return vim_item
      end,
    },

    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      {
        name = "cmdline",
        option = {
          ignore_cmds = { "Man", "!" },
        },
      },
    }),
  })
end

-- Function to determine when completion should be enabled
function M.disable_cmp()
  local context = require "cmp.config.context"
  local api = vim.api
  local fn = vim.fn

  -- Allow completion in command mode
  if api.nvim_get_mode().mode == "c" then
    return true
  end

  -- Disable in prompt buffers
  if api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end

  -- Disable while recording/executing macros
  if fn.reg_recording() ~= "" or fn.reg_executing() ~= "" then
    return false
  end

  -- Disable completion inside comments
  if context.in_treesitter_capture "comment" or context.in_syntax_group "Comment" then
    return false
  end

  return true
end

M.cmp = {
  completion = { completeopt = "menu,menuone" },

  view = {
    entries = "custom", -- can be "custom", "wildmenu" or "native"
  },

  -- Control completion activation
  enabled = M.disable_cmp,

  sources = cmp.config.sources {
    {
      name = "nvim_lsp",
      keyword_length = 2,
      group_index = 1,
      entry_filter = function(entry, _)
        local context = require "cmp.config.context"
        local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]

        -- Exclude all completions inside comments
        if context.in_treesitter_capture "comment" or context.in_syntax_group "Comment" then
          return false
        end

        -- Exclude "Text" completions globally
        if kind == "Text" then
          return false
        end

        return true
      end,
    },
    { name = "nvim_lua", keyword_length = 2, group_index = 2 },
    {
      name = "luasnip",
      keyword_length = 2,
      group_index = 3,
      entry_filter = function(_, _)
        -- Prevent all snippet completions inside comments
        local context = require "cmp.config.context"
        return not (context.in_treesitter_capture "comment" or context.in_syntax_group "Comment")
      end,
    },
    { name = "path", keyword_length = 3, group_index = 2 },
    { name = "render-markdown" },
  },
  { name = "buffer", keyword_length = 4 },

  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
    ["<C-g>"] = function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,
  },

  experimental = { ghost_text = true },
}

return M
