--[[ Notes: {{{1
Useful Links and TODO
http://cheat.sh
Buffer bar info: https://github.com/romgrk/barbar.nvim
-- }}}1 ]]


-- general
-- Settings {{{1
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.auto_complete = true
lvim.termguicolors = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- LANGUAGES -----------------------------------

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "go",
  "json",
  "lua",
  "python",
  "typescript",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.context_commentstring.enable = true
lvim.builtin.treesitter.context_commentstring.enable_autocmd = true


vim.diagnostic.config({ virtual_text = false })

lvim.builtin.gitsigns.opts.signs.add.text = ''
lvim.builtin.gitsigns.opts.signs.change.text = ''
lvim.builtin.gitsigns.opts.signs.delete.text = ''
lvim.builtin.gitsigns.opts.signs.topdelete.text = ''
lvim.builtin.gitsigns.opts.signs.changedelete.text = ''

lvim.lsp.diagnostics.signs.values = {
  { name = "LspDiagnosticsSignError", text = "" },
  { name = "LspDiagnosticsSignWarning", text = "" },
  { name = "LspDiagnosticsSignHint", text = '' },
  { name = "LspDiagnosticsSignInformation", text = "" },
}

--}}}

-- Dashboard/Alpha {{{1

lvim.builtin.alpha.dashboard.section.header.opts.hl = ""
-- Shorter ASCII art logo, so not too much space is taken up.
lvim.builtin.alpha.dashboard.section.header.val = {
  "▌              ▌ ▌▗",
  "▌  ▌ ▌▛▀▖▝▀▖▙▀▖▚▗▘▄ ▛▚▀▖",
  "▌  ▌ ▌▌ ▌▞▀▌▌  ▝▞ ▐ ▌▐ ▌",
  "▀▀▘▝▀▘▘ ▘▝▀▘▘   ▘ ▀▘▘▝ ▘",
}

lvim.builtin.alpha.dashboard.section.buttons.entries = {
  { "SPC f", "  Find File", "<CMD>Telescope find_files<CR>" },
  { "SPC n", "  New File", "<CMD>ene!<CR>" },
  { "SPC p", "  Recent Projects ", "<CMD>Telescope projects<CR>" },
  { "SPC u", "  Recently Used Files", "<CMD>Telescope oldfiles<CR>" },
  { "SPC s", "  Load last session", "<CMD>SessionLoad<CR>" },
  { "SPC r", "/  Ranger", "<CMD>RnvimrToggle<CR>" },
  { "SPC m", "  Marks              ", "<CMD>Telescope marks<CR>" },
  { "SPC w", "  Find Word", "<CMD>Telescope live_grep<CR>" },
  { "SPC c", "  Edit Configuration", "<CMD>e ~/.config/lvim/config.lua<CR>" },
  { "SPC g", "  Git status", "<CMD>Telescope git_status<CR>" }
}
--}}}
