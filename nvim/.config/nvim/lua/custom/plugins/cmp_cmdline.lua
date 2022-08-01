local formatting = {
  format = function(_, vim_item)
    vim_item.kind = ""
    return vim_item
  end,
}

local cmp = require "cmp"
cmp.setup.cmdline("/", {
  formatting = formatting,
  sources = {
    { name = "buffer" },
  },
  mapping = cmp.mapping.preset.cmdline {},
})

cmp.setup.cmdline(":", {
  formatting = formatting,
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  mapping = cmp.mapping.preset.cmdline {},
})

require("custom.autocmds").cmp()
