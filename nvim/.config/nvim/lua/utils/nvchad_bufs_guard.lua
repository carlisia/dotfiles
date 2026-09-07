-- NvChad's tabufline tracks open buffers per tab in `vim.t.bufs`. Its renderer
-- already treats "only valid buffers" as the invariant, and re-establishes it
-- on every redraw (nvchad/tabufline/modules.lua:70):
--
--   vim.t.bufs = vim.tbl_filter(vim.api.nvim_buf_is_valid, vim.t.bufs)
--
-- but the tabline does not render until there are 2+ listed buffers or 2+ tabs
-- (nvchad/tabufline/lazyload.lua:62), so nothing enforces the invariant during
-- the first stretch of a session. In that window the list can go stale: the
-- snacks dashboard takes over the startup buffer and sets buflisted=false plus
-- bufhidden=wipe on it, and wiping an unlisted buffer emits BufUnload and
-- BufWipeout but never BufDelete, which is the only cleanup hook NvChad has.
-- The dead id therefore survives in `vim.t.bufs`, and the next BufAdd reaches
-- lazyload.lua:36, which dereferences bufs[1] with no validity check:
--
--   if #api.nvim_buf_get_name(bufs[1]) == 0 and ...
--
-- That throws "Invalid buffer id", and because the throw unwinds through
-- whatever triggered the BufAdd, a snacks explorer click errors out of
-- snacks/picker/actions.lua:100 instead of opening the file.
--
-- Autocmds for one event run in registration order, and NvChad registers its
-- handler while lazy.setup() loads nvchad/ui. So this module must be required
-- from init.lua BEFORE lazy.setup() to run first; requiring it later leaves
-- NvChad reading the stale list. Still unfixed upstream as of ui@c448a23.
--
-- The list is also kept non-empty: NvChad's bufs[1] dereference has no nil
-- check either, so pruning to {} would swap one crash for another.

local api = vim.api

api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNew" }, {
  group = api.nvim_create_augroup("NvChadBufsGuard", { clear = true }),
  callback = function()
    local bufs = vim.t.bufs
    if not bufs then
      return
    end

    local kept = vim.tbl_filter(api.nvim_buf_is_valid, bufs)
    if #kept == 0 then
      kept = { api.nvim_get_current_buf() }
    end
    if #kept ~= #bufs then
      vim.t.bufs = kept
    end
  end,
})
