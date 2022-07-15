--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
lvim.plugins.path = "plugin/plugins"
-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "go",
  "json",
  "lua",
  "markdown",
  "python",
  "typescript",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false


-- local settings = require("user-conf")

-- {{{ Dashboard

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
  { "SPC r", "  Ranger", "<CMD>RnvimrToggle<CR>" },
  { "SPC m", "  Marks              ", "<CMD>Telescope marks<CR>" },
  { "SPC w", "  Find Word", "<CMD>Telescope live_grep<CR>" },
  { "SPC c", "  Edit Configuration", "<CMD>e ~/.config/lvim/config.lua<CR>" },
  { "SPC g", "  Git status", "<CMD>Telescope git_status<CR>" }
}
--}}}



-- Additional Plugins
-- lvim.plugins = {
--     {"folke/tokyonight.nvim"},
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }
