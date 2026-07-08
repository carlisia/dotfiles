-- Committed-history overlay for gitsigns.
--
-- gitsigns disables its staged layer whenever the base is a tree revision
-- (see gitsigns/manager.lua: the `rev_is_index` guard around
-- signs_staged_enable). So `change_base("~N")` collapses everything since
-- HEAD~N into a single color and cannot tell committed history from live
-- edits. This overlay fills that gap without touching gitsigns' base:
--
--   committed = diff(HEAD~N, buffer) MINUS (gitsigns hunks + hunks_staged)
--
-- gitsigns already tracks the uncommitted lines (unstaged + staged) in
-- buffer coordinates, so we only need one git operation (`git show
-- HEAD~N:relpath`), diff it against the live buffer with vim.diff, and drop
-- the lines gitsigns already owns. What remains is exactly the lines
-- introduced by the last N commits. Rendered as gutter signs and surfaced to
-- mini.map via committed_lines().

local M = {}

local ns = vim.api.nvim_create_namespace "GitsignsCommittedOverlay"

-- Per-buffer look-back depth (nil/0 = overlay off for that buffer).
local depth = {}
-- Per-buffer computed result: { [lnum] = "add" | "change" | "delete" }.
local committed = {}

local sign_text = {
  add = "│",
  change = "│",
  delete = "_",
}
local sign_hl = {
  add = "GitSignsCommittedAdd",
  change = "GitSignsCommittedChange",
  delete = "GitSignsCommittedDelete",
}

-- gitsigns cache for a buffer, or nil when the buffer is not tracked.
local function bufcache(bufnr)
  local ok, gs_cache = pcall(require, "gitsigns.cache")
  if not ok or not gs_cache then
    return nil
  end
  return gs_cache.cache[bufnr]
end

-- Buffer line numbers gitsigns already owns (unstaged + staged hunks).
-- These are excluded from the committed overlay so live edits win.
local function uncommitted_lines(bufnr)
  local set = {}
  local bcache = bufcache(bufnr)
  if not bcache then
    return set
  end
  local function collect(hunks)
    for _, h in ipairs(hunks or {}) do
      local start = h.added.start
      local count = math.max(h.added.count, 1)
      for l = start, start + count - 1 do
        set[l] = true
      end
    end
  end
  collect(bcache.hunks)
  collect(bcache.hunks_staged)
  return set
end

local function render_signs(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local map = committed[bufnr]
  if not map then
    return
  end
  local last = vim.api.nvim_buf_line_count(bufnr)
  for lnum, ty in pairs(map) do
    if lnum >= 1 and lnum <= last then
      pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, lnum - 1, 0, {
        sign_text = sign_text[ty] or "│",
        sign_hl_group = sign_hl[ty] or "GitSignsCommittedChange",
        -- Below gitsigns' default sign priority (6) so any overlap yields
        -- to the live layer. Overlap is rare: uncommitted lines are excluded.
        priority = 5,
      })
    end
  end
end

-- Recompute the overlay for a buffer, then render signs and refresh the map.
function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local n = depth[bufnr]
  if not n or n <= 0 then
    committed[bufnr] = nil
    render_signs(bufnr)
    return
  end

  local bcache = bufcache(bufnr)
  local obj = bcache and bcache.git_obj
  if not obj or not obj.relpath then
    return
  end

  local dir = vim.fs.dirname(obj.file)
  local rev = ("HEAD~%d:%s"):format(n, obj.relpath)
  local buftext = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"

  vim.system({ "git", "-C", dir, "show", rev }, { text = true }, function(res)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      -- A non-zero exit usually means the file did not exist N commits ago
      -- (added since). Treat the base as empty so the whole file counts as
      -- committed history, minus whatever is still uncommitted.
      local base_text = (res.code == 0 and res.stdout) or ""
      local hunks = vim.diff(base_text, buftext, { result_type = "indices" }) or {}
      local skip = uncommitted_lines(bufnr)
      local map = {}
      for _, h in ipairs(hunks) do
        local count_a, start_b, count_b = h[2], h[3], h[4]
        if count_b == 0 then
          local l = math.max(start_b, 1)
          if not skip[l] then
            map[l] = map[l] or "delete"
          end
        else
          local ty = count_a == 0 and "add" or "change"
          for l = start_b, start_b + count_b - 1 do
            if not skip[l] then
              map[l] = ty
            end
          end
        end
      end
      committed[bufnr] = map
      render_signs(bufnr)
      pcall(function()
        require("mini.map").refresh({}, { lines = false, scrollbar = false })
      end)
    end)
  end)
end

-- Line highlights for the mini.map integration: { {line=, hl_group=}, ... }.
function M.committed_lines(bufnr)
  local result = {}
  for lnum, ty in pairs(committed[bufnr] or {}) do
    result[#result + 1] = { line = lnum, hl_group = sign_hl[ty] or "GitSignsCommittedChange" }
  end
  return result
end

-- Set the look-back depth. When global, apply to every loaded buffer and
-- remember it as the default for buffers opened later.
function M.set_depth(n, global)
  n = tonumber(n)
  if not n then
    return
  end
  if global then
    M._global = n
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(b) then
        depth[b] = n
        M.refresh(b)
      end
    end
  else
    local b = vim.api.nvim_get_current_buf()
    depth[b] = n
    M.refresh(b)
  end
end

-- Clear the overlay (current buffer, or all buffers when global).
function M.reset(global)
  if global then
    M._global = nil
    depth = {}
    committed = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) then
        render_signs(b)
      end
    end
  else
    local b = vim.api.nvim_get_current_buf()
    depth[b] = nil
    committed[b] = nil
    render_signs(b)
  end
  pcall(function()
    require("mini.map").refresh({}, { lines = false, scrollbar = false })
  end)
end

-- Recompute on save, and when entering a buffer that inherits a global depth.
local aug = vim.api.nvim_create_augroup("GitsignsCommittedOverlay", {})
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  group = aug,
  callback = function(ev)
    local b = ev.buf
    if depth[b] == nil and M._global then
      depth[b] = M._global
    end
    if depth[b] and depth[b] > 0 then
      M.refresh(b)
    end
  end,
  desc = "Refresh committed-history overlay",
})

return M
