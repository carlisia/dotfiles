local helper = require "utils.functions"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.api.nvim_create_user_command("CreateOrOpenNote", function(opts)
      local title = opts.args
      if title == "" then
        vim.notify("Please provide a title.", vim.log.levels.WARN)
        return
      end

      local vault_main = vim.env.VAULT_MAIN or ""
      local inbox_dir = vault_main .. "/§ Inbox/"
      local filename = title:gsub("[^A-Za-z0-9 ]", "") .. ".md"
      local path = vim.fn.expand(inbox_dir .. filename)

      if vim.fn.filereadable(path) == 1 then
        vim.notify("Note exists: " .. filename, vim.log.levels.INFO)
        vim.cmd("edit " .. path)
        return
      end

      -- Generate random ID
      local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      local id = ""
      for _ = 1, 8 do
        local rand = math.random(#charset)
        id = id .. charset:sub(rand, rand)
      end
      local full_id = "nvm-" .. id

      -- Make sure inbox directory exists
      vim.fn.mkdir(inbox_dir, "p")

      -- Write frontmatter and title
      local lines = {
        "---",
        "id: " .. full_id,
        "aliases: " .. title,
        "tags: []",
        "---",
        "",
        "# " .. title,
        "",
      }
      vim.fn.writefile(lines, path)

      vim.notify("New note created: " .. filename, vim.log.levels.INFO)
      vim.cmd("edit " .. path)
    end, { nargs = "*" })
  end,
})

-- Mini files
MiniFiles = MiniFiles

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command
    Snacks.toggle.diagnostics():map "\\p"
    -- Markdown and other filetypes use conceallevel to make text easier to read:
    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 1 }):map "\\v"
    Snacks.toggle.treesitter():map "\\T"
    Snacks.toggle.inlay_hints():map "\\y"
    Snacks.toggle.indent():map "\\I"
    Snacks.toggle.dim():map "\\D"
  end,
})

-- Lint
-- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#usage
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function(args)
    local ok, lint = pcall(require, "lint")
    if ok then
      -- golangci-lint resolves imports from the module, so run it from the
      -- go.mod dir; nvim's cwd may be a repo root with the module in a subdir.
      local cwd = vim.bo[args.buf].filetype == "go" and vim.fs.root(args.buf, "go.mod") or nil
      lint.try_lint(nil, { cwd = cwd })
    end
  end,
})

-- go.nvim test floats (guihua): mini.basics starts every terminal in Terminal mode, so
-- once the job exits the first key typed closes the float and the rest of `:q` lands in
-- the code buffer; while it runs, `:q<CR>` goes to the process. Drop to Normal mode on
-- exit so `:q` works once, and let `q` close the float.
local guihua_term_augroup = vim.api.nvim_create_augroup("guihua_term", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = guihua_term_augroup,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "guihua" then
      return
    end
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, desc = "Close test output" })
  end,
})
vim.api.nvim_create_autocmd("TermClose", {
  group = guihua_term_augroup,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "guihua" then
      return
    end
    vim.schedule(function()
      if vim.api.nvim_get_current_buf() == args.buf and vim.api.nvim_get_mode().mode == "t" then
        vim.cmd.stopinsert()
      end
    end)
  end,
})

-- Mini explorer / split
-- Create mappings to modify target window via (custom) split
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    helper.map_split(buf_id, "<C-h>", "belowright horizontal")
    helper.map_split(buf_id, "<C-v>", "belowright vertical")
    helper.map_split(buf_id, "<C-t>", "tab")
  end,
})

local set_mark = function(id, path, desc)
  MiniFiles.set_bookmark(id, path, { desc = desc })
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesExplorerOpen",
  callback = function()
    set_mark("c", vim.fn.stdpath "config", "Config") -- path
    set_mark("w", vim.fn.getcwd, "Working directory") -- callable
    set_mark("~", "~", "Home directory")
  end,
})

-- Needed to add comments to sql files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.bo.commentstring = "-- %s"
  end,
})

-- Ghostty ftplugin replacement: wraps vim.treesitter.start() in pcall
-- so it fails gracefully when the parser isn't available.
-- TODO: Remove once bezhermoso/tree-sitter-ghostty adds pcall upstream.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ghostty",
  callback = function()
    vim.bo.commentstring = "# %s"
    pcall(vim.treesitter.start)
  end,
})

-- Treesitter indent: nvim-treesitter main dropped `indent = { enable = true }`.
-- Only set it where a parser exists, so other filetypes keep their own indentexpr.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Selection/cursor backgrounds per theme type: the dark navies are unreadable on a light
-- theme. Folded lines get a distinct bg; CursorLine shows through when cursor is on one.
local hl_bgs = {
  dark = { CursorLine = "#1e2d3e", Visual = "#1e3a5f", Folded = "#262e3d" },
  light = { CursorLine = "#eef1f7", Visual = "#cfe0f5", Folded = "#e6e9f0" },
}

local function theme_bgs()
  local ok, ttype = pcall(function()
    return require("base46").get_theme_tb "type"
  end)
  return hl_bgs[ok and ttype or "dark"] or hl_bgs.dark
end

-- Three-way git sign coloring, applied here (not via base46 hl_add) because
-- base46 compiles hl_add at module-load time and can snapshot an empty
-- nvconfig before chadrc merges in, silently dropping the fg. Setting the
-- groups directly after each ColorScheme/theme reload is order-independent
-- and survives theme toggles. See utils/git_committed.lua for the committed
-- layer (HEAD~N vs HEAD); unstaged/staged are gitsigns-native.
--   unstaged  (working vs index) = theme default green / grey / red (warm, bright)
--   staged    (index vs HEAD)    = teal / blue / purple             (cool, bright)
--   committed (HEAD~N vs HEAD)   = muted green / slate / rose        (dim, recedes)
local function apply_hl_overrides()
  local bgs = theme_bgs()
  vim.api.nvim_set_hl(0, "CursorLine", { bg = bgs.CursorLine })
  vim.api.nvim_set_hl(0, "Folded", { bg = bgs.Folded })
  vim.api.nvim_set_hl(0, "Visual", { bg = bgs.Visual })

  vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = "#2bb0a3" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = "#5aa2f0" })
  vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = "#b57edc" })

  vim.api.nvim_set_hl(0, "GitSignsCommittedAdd", { fg = "#5f7a5f" })
  vim.api.nvim_set_hl(0, "GitSignsCommittedChange", { fg = "#6a6f8a" })
  vim.api.nvim_set_hl(0, "GitSignsCommittedDelete", { fg = "#8a6a6a" })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    vim.schedule(apply_hl_overrides)
  end,
})

-- NvChad theme toggle (base46) does not fire ColorScheme; it emits this User
-- event after recompiling highlights, so re-apply on it too.
vim.api.nvim_create_autocmd("User", {
  pattern = "NvThemeReload",
  callback = function()
    vim.schedule(apply_hl_overrides)
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter", "WinEnter" }, {
  callback = function()
    if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
      vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
    else
      vim.api.nvim_set_hl(0, "Folded", { bg = theme_bgs().Folded })
    end
  end,
})

--- LSP
--- reacts to all LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    require("configs.lspconfig_on_attach").on_attach(client, bufnr)
  end,
})
