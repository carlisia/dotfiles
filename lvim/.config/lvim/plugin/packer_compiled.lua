-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/carlisiac/.cache/lvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/carlisiac/.cache/lvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/carlisiac/.cache/lvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/carlisiac/.cache/lvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/carlisiac/.cache/lvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    after_files = { "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/Comment.nvim/after/plugin/Comment.lua" },
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.comment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\nÒ\3\0\0\v\0\23\00166\0\0\0'\2\1\0B\0\2\0024\1\0\0006\2\2\0009\2\3\0029\2\4\0029\2\5\0029\2\6\2\15\0\2\0X\3\fÄ\21\2\1\0\22\2\0\0029\3\a\0006\5\b\0B\5\1\2'\6\t\0'\a\n\0'\b\v\0'\t\f\0'\n\r\0B\3\a\2<\3\2\0019\2\a\0006\4\14\0B\4\1\2'\5\15\0B\2\3\0029\3\16\0\18\5\2\0B\3\2\2\15\0\3\0X\4\3Ä\21\3\1\0\22\3\0\3<\2\3\0016\3\0\0'\5\17\0B\3\2\0029\3\18\3B\3\1\0016\3\0\0'\5\19\0B\3\2\0029\3\18\0035\5\20\0=\1\21\5B\3\2\0016\3\0\0'\5\22\0B\3\2\0029\3\18\3B\3\1\1K\0\1\0\"luasnip.loaders.from_snipmate\npaths\1\0\0 luasnip.loaders.from_vscode\14lazy_load\29luasnip.loaders.from_lua\17is_directory\rsnippets\19get_config_dir\22friendly-snippets\nstart\vpacker\tpack\tsite\20get_runtime_dir\15join_paths\22friendly_snippets\fsources\fluasnip\fbuiltin\tlvim\15lvim.utils\frequire\2\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20lvim.core.alpha\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25lvim.core.bufferline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  colorschemes = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/colorschemes",
    url = "https://github.com/lunarvim/colorschemes"
  },
  ["dial.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vconfig\14user.dial\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["foam.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/foam.nvim",
    url = "https://github.com/foam.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["git-blame.nvim"] = {
    config = { "\27LJ\2\nu\0\0\3\0\5\0\t6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0)\1\0\0=\1\4\0K\0\1\0\21gitblame_enabled\6g3highlight default link gitblame SpecialComment\bcmd\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/git-blame.nvim",
    url = "https://github.com/f-person/git-blame.nvim"
  },
  ["gitlinker.nvim"] = {
    config = { "\27LJ\2\n‘\1\0\0\a\0\t\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\a\0005\3\3\0006\4\0\0'\6\4\0B\4\2\0029\4\5\4=\4\6\3=\3\b\2B\0\2\1K\0\1\0\topts\1\0\0\20action_callback\20open_in_browser\22gitlinker.actions\1\0\3$add_current_line_on_normal_mode\2\14print_url\1\rmappings\15<leader>gy\nsetup\14gitlinker\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/gitlinker.nvim",
    url = "https://github.com/ruifm/gitlinker.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  lazygit = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/lazygit",
    url = "https://github.com/jesseduffield/lazygit"
  },
  ["lightspeed.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/lsp-colors.nvim",
    url = "https://github.com/folke/lsp-colors.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/lua-dev.nvim",
    url = "https://github.com/max397574/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.lualine\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n’\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\5\22respect_scrolloff\1\24use_local_scrolloff\1\rstop_eof\2\16hide_cursor\2\25cursor_scrolls_alone\2\1\n\0\0\n<C-u>\n<C-d>\n<C-b>\n<C-f>\n<C-y>\n<C-e>\azt\azz\azb\nsetup\14neoscroll\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  ["nlsp-settings.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nlsp-settings.nvim",
    url = "https://github.com/tamago324/nlsp-settings.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\2\nX\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\20show_cursorline\2\17show_numbers\2\nsetup\tnumb\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvcode-color-schemes.vim"] = {
    config = { "\27LJ\2\nô\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\14highlight\fdisable\1\3\0\0\6c\trust\1\0\1\venable\2\1\0\1\21ensure_installed\ball\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvcode-color-schemes.vim",
    url = "https://github.com/christianchiarulli/nvcode-color-schemes.vim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.autopairs\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\nı\2\0\0\6\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\0025\3\b\0=\3\t\0025\3\15\0005\4\v\0005\5\n\0=\5\f\0045\5\r\0=\5\14\4=\4\16\3=\3\17\2B\0\2\1K\0\1\0\vfilter\bfzf\1\0\0\15extra_opts\1\5\0\0\v--bind\22ctrl-o:toggle-all\r--prompt\a> \15action_for\1\0\0\1\0\1\vctrl-s\nsplit\rfunc_map\1\0\3\14stoggleup\5\16ptogglemode\az,\vvsplit\5\fpreview\17border_chars\1\n\0\0\b‚îÉ\b‚îÉ\b‚îÅ\b‚îÅ\b‚îè\b‚îì\b‚îó\b‚îõ\b‚ñà\1\0\3\16win_vheight\3\f\15win_height\3\f\17delay_syntax\3P\1\0\1\16auto_enable\2\nsetup\bbqf\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n`\0\0\3\0\6\0\v6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\5Ä6\0\3\0'\2\4\0B\0\2\0029\0\5\0B\0\1\1K\0\1\0\nsetup\18lvim.core.cmp\frequire\bcmp\fbuiltin\tlvim\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\nì\1\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\t\vrgb_fn\2\rRRGGBBAA\2\vRRGGBB\2\bRGB\2\tmode\15background\bcss\2\nnames\2\vcss_fn\2\vhsl_fn\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-lsp-installer"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21lvim.core.notify\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.nvimtree\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25lvim.core.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { "\27LJ\2\n£\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\rpatterns\fdefault\1\0\0\1\4\0\0\nclass\rfunction\vmethod\1\0\3\14max_lines\3\0\venable\2\rthrottle\2\nsetup\23treesitter-context\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/romgrk/nvim-treesitter-context"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    config = { "\27LJ\2\nß/\0\0\6\0´\1\0ﬂ\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0024\3\0\0=\3\6\0025\3\a\0=\3\b\0025\3:\0005\4\n\0005\5\t\0=\5\v\0045\5\f\0=\5\r\0045\5\14\0=\5\15\0045\5\16\0=\5\17\0045\5\18\0=\5\19\0045\5\20\0=\5\21\0045\5\22\0=\5\23\0045\5\24\0=\5\25\0045\5\26\0=\5\27\0045\5\28\0=\5\29\0045\5\30\0=\5\31\0045\5 \0=\5!\0045\5\"\0=\5#\0045\5$\0=\5%\0045\5&\0=\5'\0045\5(\0=\5)\0045\5*\0=\5+\0045\5,\0=\5-\0045\5.\0=\5/\0045\0050\0=\0051\0045\0052\0=\0053\0045\0054\0=\0055\0045\0056\0=\0057\0045\0058\0=\0059\4=\4;\0035\4=\0005\5<\0=\5>\0045\5?\0=\5@\0045\5A\0=\5B\0045\5C\0=\5D\0045\5E\0=\5F\0045\5G\0=\5H\0045\5I\0=\5J\0045\5K\0=\5L\0045\5M\0=\5\v\0045\5N\0=\5\r\0045\5O\0=\5\15\0045\5P\0=\5\17\0045\5Q\0=\5\19\0045\5R\0=\5\21\0045\5S\0=\5T\0045\5U\0=\5\23\0045\5V\0=\5\25\0045\5W\0=\5\27\0045\5X\0=\5\29\0045\5Y\0=\5\31\0045\5Z\0=\5!\0045\5[\0=\5#\0045\5\\\0=\5%\0045\5]\0=\5'\0045\5^\0=\5)\0045\5_\0=\5+\0045\5`\0=\5-\0045\5a\0=\5/\0045\5b\0=\0051\0045\5c\0=\0053\0045\5d\0=\0055\0045\5e\0=\0057\0045\5f\0=\0059\4=\4g\0035\4i\0005\5h\0=\5!\0045\5j\0=\5#\0045\5k\0=\5l\0045\5m\0=\5%\0045\5n\0=\5'\0045\5o\0=\5)\0045\5p\0=\5q\0045\5r\0=\5s\0045\5t\0=\5u\0045\5v\0=\5+\0045\5w\0=\5-\0045\5x\0=\5/\0045\5y\0=\0051\0045\5z\0=\0053\0045\5{\0=\0055\0045\5|\0=\0057\0045\5}\0=\0059\4=\4~\0035\4Ä\0005\5\0=\5Å\0045\5Ç\0=\5É\0045\5Ñ\0=\5Ö\0045\5Ü\0=\5u\4=\4á\0035\4â\0005\5à\0=\5ä\0045\5ã\0=\5å\0045\5ç\0=\5é\0045\5è\0=\5ê\0045\5ë\0=\5í\0045\5ì\0=\5î\0045\5ï\0=\5q\0045\5ñ\0=\5s\0045\5ó\0=\5u\0045\5ò\0=\5ô\4=\4ö\0035\4ú\0005\5õ\0=\5ù\0045\5û\0=\5ü\0045\5†\0=\5°\0045\5¢\0=\5£\0045\5§\0=\5é\0045\5•\0=\5ê\0045\5¶\0=\5q\0045\5ß\0=\5s\0045\5®\0=\5u\0045\5©\0=\5ô\4=\4\b\3=\3™\2B\0\2\1K\0\1\0\rmappings\1\0\2\blhs\20<leader><space>\tdesc\31toggle viewer viewed state\1\0\2\blhs\n<C-c>\tdesc\21close review tab\1\0\2\blhs\a[q\tdesc\30move to next changed file\1\0\2\blhs\a]q\tdesc\"move to previous changed file\1\0\2\blhs\14<leader>b\tdesc\"hide/show changed files panel\1\0\2\blhs\14<leader>e\tdesc%move focus to changed file panel\18refresh_files\1\0\2\blhs\6R\tdesc refresh changed files panel\17select_entry\1\0\2\blhs\t<cr>\tdesc%show selected changed file diffs\15prev_entry\1\0\2\blhs\6k\tdesc\"move to previous changed file\15next_entry\1\0\0\1\0\2\blhs\6j\tdesc\30move to next changed file\16review_diff\18toggle_viewed\1\0\2\blhs\20<leader><space>\tdesc\31toggle viewer viewed state\1\0\2\blhs\n<C-c>\tdesc\21close review tab\1\0\2\blhs\a[q\tdesc\30move to next changed file\1\0\2\blhs\a]q\tdesc\"move to previous changed file\16prev_thread\1\0\2\blhs\a[t\tdesc\28move to previous thread\16next_thread\1\0\2\blhs\a]t\tdesc\24move to next thread\17toggle_files\1\0\2\blhs\14<leader>b\tdesc\"hide/show changed files panel\16focus_files\1\0\2\blhs\14<leader>e\tdesc%move focus to changed file panel\26add_review_suggestion\1\0\2\blhs\14<space>sa\tdesc add a new review suggestion\23add_review_comment\1\0\0\1\0\2\blhs\14<space>ca\tdesc\29add a new review comment\15submit_win\1\0\2\blhs\n<C-c>\tdesc\21close review tab\20request_changes\1\0\2\blhs\n<C-r>\tdesc\27request changes review\19comment_review\1\0\2\blhs\n<C-m>\tdesc\19comment review\19approve_review\1\0\0\1\0\2\blhs\n<C-a>\tdesc\19approve review\18review_thread\1\0\2\blhs\14<space>rc\tdesc\29add/remove üòï reaction\1\0\2\blhs\14<space>rl\tdesc\29add/remove üòÑ reaction\1\0\2\blhs\14<space>rr\tdesc\29add/remove üöÄ reaction\1\0\2\blhs\14<space>r-\tdesc\29add/remove üëé reaction\1\0\2\blhs\14<space>r+\tdesc\29add/remove üëç reaction\1\0\2\blhs\14<space>re\tdesc\29add/remove üëÄ reaction\1\0\2\blhs\14<space>rh\tdesc\31add/remove ‚ù§Ô∏è reaction\1\0\2\blhs\14<space>rp\tdesc\29add/remove üéâ reaction\21close_review_tab\1\0\2\blhs\n<C-c>\tdesc\21close review tab\22select_prev_entry\1\0\2\blhs\a[q\tdesc\30move to next changed file\22select_next_entry\1\0\2\blhs\a]q\tdesc\"move to previous changed file\1\0\2\blhs\a[c\tdesc\27go to previous comment\1\0\2\blhs\a]c\tdesc\23go to next comment\1\0\2\blhs\14<space>cd\tdesc\19delete comment\19add_suggestion\1\0\2\blhs\14<space>sa\tdesc\19add suggestion\1\0\2\blhs\14<space>ca\tdesc\16add comment\1\0\0\1\0\2\blhs\14<space>gi\tdesc#navigate to a local repo issue\17pull_request\1\0\2\blhs\14<space>rc\tdesc\29add/remove üòï reaction\1\0\2\blhs\14<space>rl\tdesc\29add/remove üòÑ reaction\1\0\2\blhs\14<space>rr\tdesc\29add/remove üöÄ reaction\1\0\2\blhs\14<space>r-\tdesc\29add/remove üëé reaction\1\0\2\blhs\14<space>r+\tdesc\29add/remove üëç reaction\1\0\2\blhs\14<space>re\tdesc\29add/remove üëÄ reaction\1\0\2\blhs\14<space>rh\tdesc\31add/remove ‚ù§Ô∏è reaction\1\0\2\blhs\14<space>rp\tdesc\29add/remove üéâ reaction\1\0\2\blhs\a[c\tdesc\27go to previous comment\1\0\2\blhs\a]c\tdesc\23go to next comment\1\0\2\blhs\14<space>cd\tdesc\19delete comment\1\0\2\blhs\14<space>ca\tdesc\16add comment\1\0\2\blhs\14<space>gi\tdesc#navigate to a local repo issue\1\0\2\blhs\14<space>ld\tdesc\17remove label\1\0\2\blhs\14<space>la\tdesc\14add label\1\0\2\blhs\14<space>lc\tdesc\17create label\1\0\2\blhs\14<space>ad\tdesc\20remove assignee\1\0\2\blhs\14<space>aa\tdesc\17add assignee\14goto_file\1\0\2\blhs\agf\tdesc\15go to file\1\0\2\blhs\n<C-y>\tdesc!copy url to system clipboard\1\0\2\blhs\n<C-b>\tdesc\23open PR in browser\1\0\2\blhs\n<C-r>\tdesc\14reload PR\1\0\2\blhs\14<space>il\tdesc\"list open issues on same repo\1\0\2\blhs\14<space>io\tdesc\14reopen PR\1\0\2\blhs\14<space>ic\tdesc\rclose PR\20remove_reviewer\1\0\2\blhs\14<space>vd\tdesc\28remove reviewer request\17add_reviewer\1\0\2\blhs\14<space>va\tdesc\17add reviewer\17show_pr_diff\1\0\2\blhs\14<space>pd\tdesc\17show PR diff\23list_changed_files\1\0\2\blhs\14<space>pf\tdesc\26list PR changed files\17list_commits\1\0\2\blhs\14<space>pc\tdesc\20list PR commits\24squash_and_merge_pr\1\0\2\blhs\15<space>psm\tdesc\24squash and merge PR\rmerge_pr\1\0\2\blhs\14<space>pm\tdesc\20merge commit PR\16checkout_pr\1\0\0\1\0\2\blhs\14<space>po\tdesc\16checkout PR\nissue\1\0\0\19react_confused\1\0\2\blhs\14<space>rc\tdesc\29add/remove üòï reaction\16react_laugh\1\0\2\blhs\14<space>rl\tdesc\29add/remove üòÑ reaction\17react_rocket\1\0\2\blhs\14<space>rr\tdesc\29add/remove üöÄ reaction\22react_thumbs_down\1\0\2\blhs\14<space>r-\tdesc\29add/remove üëé reaction\20react_thumbs_up\1\0\2\blhs\14<space>r+\tdesc\29add/remove üëç reaction\15react_eyes\1\0\2\blhs\14<space>re\tdesc\29add/remove üëÄ reaction\16react_heart\1\0\2\blhs\14<space>rh\tdesc\31add/remove ‚ù§Ô∏è reaction\17react_hooray\1\0\2\blhs\14<space>rp\tdesc\29add/remove üéâ reaction\17prev_comment\1\0\2\blhs\a[c\tdesc\27go to previous comment\17next_comment\1\0\2\blhs\a]c\tdesc\23go to next comment\19delete_comment\1\0\2\blhs\14<space>cd\tdesc\19delete comment\16add_comment\1\0\2\blhs\14<space>ca\tdesc\16add comment\15goto_issue\1\0\2\blhs\14<space>gi\tdesc#navigate to a local repo issue\17remove_label\1\0\2\blhs\14<space>ld\tdesc\17remove label\14add_label\1\0\2\blhs\14<space>la\tdesc\14add label\17create_label\1\0\2\blhs\14<space>lc\tdesc\17create label\20remove_assignee\1\0\2\blhs\14<space>ad\tdesc\20remove assignee\17add_assignee\1\0\2\blhs\14<space>aa\tdesc\17add assignee\rcopy_url\1\0\2\blhs\n<C-y>\tdesc!copy url to system clipboard\20open_in_browser\1\0\2\blhs\n<C-b>\tdesc\26open issue in browser\vreload\1\0\2\blhs\n<C-r>\tdesc\17reload issue\16list_issues\1\0\2\blhs\14<space>il\tdesc\"list open issues on same repo\17reopen_issue\1\0\2\blhs\14<space>io\tdesc\17reopen issue\16close_issue\1\0\0\1\0\2\blhs\14<space>ic\tdesc\16close issue\15file_panel\1\0\2\14use_icons\2\tsize\3\n\16ssh_aliases\19default_remote\1\0\b\30reaction_viewer_hint_icon\bÔëÑ\26snippet_context_lines\3\4\20github_hostname\5\26left_bubble_delimiter\bÓÇ∂\27right_bubble_delimiter\bÓÇ¥\20timeline_indent\0062\20timeline_marker\bÔë†\14user_icon\tÔäΩ \1\3\0\0\rupstream\vorigin\nsetup\tocto\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["onedarkpro.nvim"] = {
    config = { "\27LJ\2\n“\6\0\0\6\0\30\0#6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0024\3\0\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\v\0005\4\n\0=\4\f\3=\3\r\0025\3\17\0005\4\15\0005\5\14\0=\5\16\4=\4\18\0035\4\20\0005\5\19\0=\5\21\4=\4\22\3=\3\23\0025\3\25\0005\4\24\0=\4\26\0035\4\27\0=\4\28\3=\3\29\2B\0\2\1K\0\1\0\29filetype_hlgroups_ignore\rbuftypes\1\2\0\0\15^terminal$\14filetypes\1\0\0\1\16\0\0\r^aerial$\f^alpha$\15^fugitive$\20^fugitiveblame$\v^help$\15^NvimTree$\r^packer$\t^qf$\15^startify$\18^startuptime$\22^TelescopePrompt$\23^TelescopeResults$\15^terminal$\17^toggleterm$\15^undotree$\22filetype_hlgroups\vpython\18TSConstructor\1\0\0\1\0\2\abg\v${red}\afg\n${bg}\tyaml\1\0\0\fTSField\1\0\0\1\0\1\afg\v${red}\rhlgroups\fComment\1\0\0\1\0\3\nstyle\16bold,italic\abg\14${yellow}\afg\18${my_new_red}\foptions\1\0\b\14underline\1\28window_unfocussed_color\1\20terminal_colors\2\17transparency\1\14undercurl\1\15cursorline\1\vitalic\1\tbold\1\vstyles\1\0\6\17virtual_text\tNONE\fstrings\tNONE\rcomments\tNONE\14variables\tNONE\14functions\tNONE\rkeywords\tNONE\fplugins\vcolors\1\0\2\16light_theme\ronelight\15dark_theme\fonedark\nsetup\15onedarkpro\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/onedarkpro.nvim",
    url = "https://github.com/olimorris/onedarkpro.nvim"
  },
  ["onenord.nvim"] = {
    config = { "\27LJ\2\n¯\2\0\0\5\0\16\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\v\0005\4\n\0=\4\f\3=\3\r\0025\3\14\0=\3\15\2B\0\2\1K\0\1\0\18custom_colors\1\0\1\bred\f#ffffff\22custom_highlights\18TSConstructor\1\0\0\1\0\1\afg\14dark_blue\finverse\1\0\1\16match_paren\2\fdisable\1\0\3\15cursorline\1\14eob_lines\2\15background\1\vstyles\1\0\5\16diagnostics\14underline\fstrings\tNONE\14variables\tNONE\14functions\tNONE\rkeywords\tNONE\1\0\3\ntheme\tdark\ffade_nc\1\fborders\2\nsetup\fonenord\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/onenord.nvim",
    url = "https://github.com/rmehri01/onenord.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["project.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.project\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/project.nvim",
    url = "https://github.com/ahmedkhalf/project.nvim"
  },
  rnvimr = {
    commands = { "RnvimrToggle" },
    config = { "\27LJ\2\nx\0\0\2\0\5\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0K\0\1\0\21rnvimr_bw_enable\23rnvimr_pick_enable\23rnvimr_draw_border\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/rnvimr",
    url = "https://github.com/kevinhwang91/rnvimr"
  },
  ["schemastore.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/schemastore.nvim",
    url = "https://github.com/b0o/schemastore.nvim"
  },
  ["structlog.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/structlog.nvim",
    url = "https://github.com/Tastyep/structlog.nvim"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/telescope-fzy-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzy-native.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.telescope\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.terminal\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["trld.nvim"] = {
    config = { "\27LJ\2\n¥\2\0\1\17\0\14\1.6\1\0\0'\3\1\0B\1\2\0024\2\0\0009\3\2\0\18\5\3\0009\3\3\3'\6\4\0B\3\3\4X\6\vÄ\18\t\6\0009\a\5\6'\n\6\0'\v\a\0B\a\4\2\18\6\a\0006\a\b\0009\a\t\a\18\t\2\0\18\n\6\0B\a\3\1E\6\3\2R\6Û4\3\0\0006\4\n\0\18\6\2\0B\4\2\4X\a\15Ä6\t\b\0009\t\t\t\18\v\3\0004\f\3\0004\r\3\0\18\14\b\0'\15\v\0&\14\15\14>\14\1\r9\14\f\0019\16\r\0B\14\2\0?\14\0\0>\r\1\fB\t\3\1E\a\3\3R\aÔL\3\2\0\rseverity\24get_hl_by_serverity\6 \vipairs\vinsert\ntable\5\18[ \t]+%f[\r\n%z]\tgsub\n[^\n]+\vgmatch\fmessage\15trld.utils\frequire\5ÄÄ¿ô\4Ï\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14formatter\0\15highlights\1\0\4\nerror\28DiagnosticFloatingError\twarn\27DiagnosticFloatingWarn\thint\27DiagnosticFloatingHint\tinfo\27DiagnosticFloatingInfo\1\0\2\rposition\btop\14auto_cmds\2\nsetup\ttrld\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/trld.nvim",
    url = "https://github.com/Mofiqul/trld.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "TroubleToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-fugitive"] = {
    commands = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    config = { "\27LJ\2\nN\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\0\1\vmethod\npopup!matchup_matchparen_offscreen\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-signature"] = {
    after_files = { "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-signature/after/plugin/signature.vim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-signature",
    url = "https://github.com/kshenoy/vim-signature"
  },
  ["vim-surround"] = {
    keys = { { "", "c" }, { "", "d" }, { "", "y" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vscode.nvim"] = {
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/vscode.nvim",
    url = "https://github.com/Mofiqul/vscode.nvim"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.which-key\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/which-key.nvim",
    url = "https://github.com/max397574/which-key.nvim"
  },
  ["zephyr-nvim"] = {
    config = { "\27LJ\2\nY\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\bopt\2\nsetup$nvim-treesitter/nvim-treesitter\frequire\0" },
    loaded = true,
    path = "/Users/carlisiac/.local/share/lunarvim/site/pack/packer/start/zephyr-nvim",
    url = "https://github.com/glepnir/zephyr-nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^lua%-dev"] = "lua-dev.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: indent-blankline.nvim
time([[Setup for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\n„\2\0\0\2\0\v\0\0256\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0006\0\0\0009\0\1\0005\1\b\0=\1\a\0006\0\0\0009\0\1\0+\1\1\0=\1\t\0006\0\0\0009\0\1\0+\1\1\0=\1\n\0K\0\1\0-indent_blankline_show_first_indent_level4indent_blankline_show_trailing_blankline_indent\1\2\0\0\rterminal%indent_blankline_buftype_exclude\1\4\0\0\thelp\rterminal\14dashboard&indent_blankline_filetype_exclude\b‚ñè\26indent_blankline_char\23indentLine_enabled\6g\bvim\0", "setup", "indent-blankline.nvim")
time([[Setup for indent-blankline.nvim]], false)
-- Setup for: telescope-project.nvim
time([[Setup for telescope-project.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27packadd telescope.nvim\bcmd\bvim\0", "setup", "telescope-project.nvim")
time([[Setup for telescope-project.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.lualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: project.nvim
time([[Config for project.nvim]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22lvim.core.project\frequire\0", "config", "project.nvim")
time([[Config for project.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\nÒ\3\0\0\v\0\23\00166\0\0\0'\2\1\0B\0\2\0024\1\0\0006\2\2\0009\2\3\0029\2\4\0029\2\5\0029\2\6\2\15\0\2\0X\3\fÄ\21\2\1\0\22\2\0\0029\3\a\0006\5\b\0B\5\1\2'\6\t\0'\a\n\0'\b\v\0'\t\f\0'\n\r\0B\3\a\2<\3\2\0019\2\a\0006\4\14\0B\4\1\2'\5\15\0B\2\3\0029\3\16\0\18\5\2\0B\3\2\2\15\0\3\0X\4\3Ä\21\3\1\0\22\3\0\3<\2\3\0016\3\0\0'\5\17\0B\3\2\0029\3\18\3B\3\1\0016\3\0\0'\5\19\0B\3\2\0029\3\18\0035\5\20\0=\1\21\5B\3\2\0016\3\0\0'\5\22\0B\3\2\0029\3\18\3B\3\1\1K\0\1\0\"luasnip.loaders.from_snipmate\npaths\1\0\0 luasnip.loaders.from_vscode\14lazy_load\29luasnip.loaders.from_lua\17is_directory\rsnippets\19get_config_dir\22friendly-snippets\nstart\vpacker\tpack\tsite\20get_runtime_dir\15join_paths\22friendly_snippets\fsources\fluasnip\fbuiltin\tlvim\15lvim.utils\frequire\2\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\nì\1\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\t\vrgb_fn\2\rRRGGBBAA\2\vRRGGBB\2\bRGB\2\tmode\15background\bcss\2\nnames\2\vcss_fn\2\vhsl_fn\2\1\2\0\0\6*\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: nvcode-color-schemes.vim
time([[Config for nvcode-color-schemes.vim]], true)
try_loadstring("\27LJ\2\nô\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\14highlight\fdisable\1\3\0\0\6c\trust\1\0\1\venable\2\1\0\1\21ensure_installed\ball\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvcode-color-schemes.vim")
time([[Config for nvcode-color-schemes.vim]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
try_loadstring("\27LJ\2\n£\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\rpatterns\fdefault\1\0\0\1\4\0\0\nclass\rfunction\vmethod\1\0\3\14max_lines\3\0\venable\2\rthrottle\2\nsetup\23treesitter-context\frequire\0", "config", "nvim-treesitter-context")
time([[Config for nvim-treesitter-context]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23lvim.core.nvimtree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: trld.nvim
time([[Config for trld.nvim]], true)
try_loadstring("\27LJ\2\n¥\2\0\1\17\0\14\1.6\1\0\0'\3\1\0B\1\2\0024\2\0\0009\3\2\0\18\5\3\0009\3\3\3'\6\4\0B\3\3\4X\6\vÄ\18\t\6\0009\a\5\6'\n\6\0'\v\a\0B\a\4\2\18\6\a\0006\a\b\0009\a\t\a\18\t\2\0\18\n\6\0B\a\3\1E\6\3\2R\6Û4\3\0\0006\4\n\0\18\6\2\0B\4\2\4X\a\15Ä6\t\b\0009\t\t\t\18\v\3\0004\f\3\0004\r\3\0\18\14\b\0'\15\v\0&\14\15\14>\14\1\r9\14\f\0019\16\r\0B\14\2\0?\14\0\0>\r\1\fB\t\3\1E\a\3\3R\aÔL\3\2\0\rseverity\24get_hl_by_serverity\6 \vipairs\vinsert\ntable\5\18[ \t]+%f[\r\n%z]\tgsub\n[^\n]+\vgmatch\fmessage\15trld.utils\frequire\5ÄÄ¿ô\4Ï\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\14formatter\0\15highlights\1\0\4\nerror\28DiagnosticFloatingError\twarn\27DiagnosticFloatingWarn\thint\27DiagnosticFloatingHint\tinfo\27DiagnosticFloatingInfo\1\0\2\rposition\btop\14auto_cmds\2\nsetup\ttrld\frequire\0", "config", "trld.nvim")
time([[Config for trld.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n`\0\0\3\0\6\0\v6\0\0\0009\0\1\0009\0\2\0\15\0\0\0X\1\5Ä6\0\3\0'\2\4\0B\0\2\0029\0\5\0B\0\1\1K\0\1\0\nsetup\18lvim.core.cmp\frequire\bcmp\fbuiltin\tlvim\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: onenord.nvim
time([[Config for onenord.nvim]], true)
try_loadstring("\27LJ\2\n¯\2\0\0\5\0\16\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\v\0005\4\n\0=\4\f\3=\3\r\0025\3\14\0=\3\15\2B\0\2\1K\0\1\0\18custom_colors\1\0\1\bred\f#ffffff\22custom_highlights\18TSConstructor\1\0\0\1\0\1\afg\14dark_blue\finverse\1\0\1\16match_paren\2\fdisable\1\0\3\15cursorline\1\14eob_lines\2\15background\1\vstyles\1\0\5\16diagnostics\14underline\fstrings\tNONE\14variables\tNONE\14functions\tNONE\rkeywords\tNONE\1\0\3\ntheme\tdark\ffade_nc\1\fborders\2\nsetup\fonenord\frequire\0", "config", "onenord.nvim")
time([[Config for onenord.nvim]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20lvim.core.alpha\frequire\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24lvim.core.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: zephyr-nvim
time([[Config for zephyr-nvim]], true)
try_loadstring("\27LJ\2\nY\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\bopt\2\nsetup$nvim-treesitter/nvim-treesitter\frequire\0", "config", "zephyr-nvim")
time([[Config for zephyr-nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25lvim.core.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: onedarkpro.nvim
time([[Config for onedarkpro.nvim]], true)
try_loadstring("\27LJ\2\n“\6\0\0\6\0\30\0#6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\0024\3\0\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\v\0005\4\n\0=\4\f\3=\3\r\0025\3\17\0005\4\15\0005\5\14\0=\5\16\4=\4\18\0035\4\20\0005\5\19\0=\5\21\4=\4\22\3=\3\23\0025\3\25\0005\4\24\0=\4\26\0035\4\27\0=\4\28\3=\3\29\2B\0\2\1K\0\1\0\29filetype_hlgroups_ignore\rbuftypes\1\2\0\0\15^terminal$\14filetypes\1\0\0\1\16\0\0\r^aerial$\f^alpha$\15^fugitive$\20^fugitiveblame$\v^help$\15^NvimTree$\r^packer$\t^qf$\15^startify$\18^startuptime$\22^TelescopePrompt$\23^TelescopeResults$\15^terminal$\17^toggleterm$\15^undotree$\22filetype_hlgroups\vpython\18TSConstructor\1\0\0\1\0\2\abg\v${red}\afg\n${bg}\tyaml\1\0\0\fTSField\1\0\0\1\0\1\afg\v${red}\rhlgroups\fComment\1\0\0\1\0\3\nstyle\16bold,italic\abg\14${yellow}\afg\18${my_new_red}\foptions\1\0\b\14underline\1\28window_unfocussed_color\1\20terminal_colors\2\17transparency\1\14undercurl\1\15cursorline\1\vitalic\1\tbold\1\vstyles\1\0\6\17virtual_text\tNONE\fstrings\tNONE\rcomments\tNONE\14variables\tNONE\14functions\tNONE\rkeywords\tNONE\fplugins\vcolors\1\0\2\16light_theme\ronelight\15dark_theme\fonedark\nsetup\15onedarkpro\frequire\0", "config", "onedarkpro.nvim")
time([[Config for onedarkpro.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21lvim.core.notify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GDelete lua require("packer.load")({'vim-fugitive'}, { cmd = "GDelete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GBrowse lua require("packer.load")({'vim-fugitive'}, { cmd = "GBrowse", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GRemove lua require("packer.load")({'vim-fugitive'}, { cmd = "GRemove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GRename lua require("packer.load")({'vim-fugitive'}, { cmd = "GRename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Glgrep lua require("packer.load")({'vim-fugitive'}, { cmd = "Glgrep", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gedit lua require("packer.load")({'vim-fugitive'}, { cmd = "Gedit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file RnvimrToggle lua require("packer.load")({'rnvimr'}, { cmd = "RnvimrToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TroubleToggle lua require("packer.load")({'trouble.nvim'}, { cmd = "TroubleToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gdiffsplit lua require("packer.load")({'vim-fugitive'}, { cmd = "Gdiffsplit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file G lua require("packer.load")({'vim-fugitive'}, { cmd = "G", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gread lua require("packer.load")({'vim-fugitive'}, { cmd = "Gread", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Gwrite lua require("packer.load")({'vim-fugitive'}, { cmd = "Gwrite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Ggrep lua require("packer.load")({'vim-fugitive'}, { cmd = "Ggrep", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file GMove lua require("packer.load")({'vim-fugitive'}, { cmd = "GMove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> c <cmd>lua require("packer.load")({'vim-surround'}, { keys = "c", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> d <cmd>lua require("packer.load")({'vim-surround'}, { keys = "d", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> y <cmd>lua require("packer.load")({'vim-surround'}, { keys = "y", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType fugitive ++once lua require("packer.load")({'vim-fugitive'}, { ft = "fugitive" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufRead * ++once lua require("packer.load")({'lightspeed.nvim', 'lsp-colors.nvim', 'Comment.nvim', 'indent-blankline.nvim', 'git-blame.nvim', 'gitsigns.nvim', 'vim-surround', 'octo.nvim', 'nvim-bqf', 'vim-signature', 'dial.nvim', 'telescope-fzy-native.nvim', 'gitlinker.nvim', 'numb.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au BufWinEnter * ++once lua require("packer.load")({'which-key.nvim', 'telescope-project.nvim', 'bufferline.nvim', 'toggleterm.nvim'}, { event = "BufWinEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CursorMoved * ++once lua require("packer.load")({'vim-matchup'}, { event = "CursorMoved *" }, _G.packer_plugins)]]
vim.cmd [[au WinScrolled * ++once lua require("packer.load")({'neoscroll.nvim'}, { event = "WinScrolled *" }, _G.packer_plugins)]]
vim.cmd [[au BufReadPost * ++once lua require("packer.load")({'nvim-ts-context-commentstring'}, { event = "BufReadPost *" }, _G.packer_plugins)]]
vim.cmd [[au BufNew * ++once lua require("packer.load")({'nvim-bqf'}, { event = "BufNew *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-fugitive/ftdetect/fugitive.vim]], true)
vim.cmd [[source /Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-fugitive/ftdetect/fugitive.vim]]
time([[Sourcing ftdetect script at: /Users/carlisiac/.local/share/lunarvim/site/pack/packer/opt/vim-fugitive/ftdetect/fugitive.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
