local M = {}

M.cmp = function()
  local present, cmp = pcall(require, "mp")

  if not present then
    return
  end

  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
    mapping = cmp.mapping.preset.cmdline({}),
  })
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
    mapping = cmp.mapping.preset.cmdline({}),
  })

end

return M

