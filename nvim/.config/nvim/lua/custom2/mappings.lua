local M = {}

local Terminal = require("toggleterm.terminal").Terminal
local toggle_float = function()
  local float = Terminal:new({ direction = "float" })
  return float:toggle()
end
local toggle_lazygit = function()
  local lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
  return lazygit:toggle()
end

M.keys = {
  [";"] = { "<cmd>Alpha<CR>", "dash" },

  ["/"] = "which_key_ignore",
  e = { "<cmd> NvimTreeToggle <CR>", "which_key_ignore" },
  n = { "<cmd>Telescope notify<cr>", "which_key_ignore" },
  b = "which_key_ignore",
  c = "which_key_ignore",
  -- TODO: out set number line somewhere
  r = "which_key_ignore",
  v = "which_key_ignore",
  x = "which_key_ignore",

  d = {
    name = "diagnostics",
    R = { "<cmd>Lspsaga rename<cr>", "Rename" },
    a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
    e = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show Line Diagnostics" },
    n = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Go To Next Diagnostic" },

    --    	buf_k("n", m.workspace_diagnostics, function()
    -- 	if vim.diagnostic.get()[1] then
    -- 		require("trouble").open("workspace_diagnostics")
    -- 	else
    -- 		vim.notify("No workspace diagnostics found.")
    -- 	end
    -- end)
    -- --
    -- buf_k("n", m.buffer_diagnostics, function()
    -- 	if vim.diagnostic.get()[1] then
    -- 		require("trouble").open("document_diagnostics")
    -- 	else
    -- 		vim.notify("No docunment diagnostics found.")
    -- 	end
    -- end)

    f = {
      function()
        vim.diagnostic.open_float()
      end,
      "   floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "   goto prev",
    },

    ["d]"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "   goto_next",
    },

    q = {
      function()
        vim.diagnostic.setloclist()
      end,
      "   diagnostic setloclist",
    },

    -- ["<leader>ra"] = {
    --   function()
    --     require("nvchad_ui.renamer").open()
    --   end,
    --   "   lsp rename",
    -- },

    -- ["ca"] = {
    -- 	function()
    -- 		vim.lsp.buf.code_action()
    -- 	end,
    -- 	"   lsp code_action",
    -- },
  },

  f = {
    name = "  file handling",

    a = "which_key_ignore",
    b = "which_key_ignore",
    f = "which_key_ignore",
    h = "which_key_ignore",
    o = "which_key_ignore",

    m = {
      function()
        vim.lsp.buf.formatting()
      end,
      " formatt",
    },
    w = { ":w<cr>", "Write" },
    x = { ":bdelete<cr>", "Close" },
    q = { ":q<cr>", "Quit" },
    s = { ":wq<cr>", "Save  & Quit" },
    S = { ":wa<cr>", "Save All" },
    Q = { ":qa<cr>", "Quit All" },
  },

  z = { toggle_lazygit, "!!! LazyGit" },
  g = {
    name = "git",
    t = "which_key_ignore",

    b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },

    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    -- b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "!!! Git Diff" },

    c = { "<cmd> Telescope git_commits <CR>", "!!!    git commits" },
    s = { "<cmd> Telescope git_status <CR>", "!!!   git status" },

    h = {
      name = "Hunk stuff",
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },

      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
      j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    },
  },

  p = {
    l = { "<CMD>Telescope project<CR>", "  Recent Projects" },

    t = "which_key_ignore",
  },

  P = {
    name = "Packer",
    c = { "<cmd>PackerLoad<cr>", "Load" },
    -- c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    -- TODO: reload config
    -- r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
    -- s = { "<cmd>PackerSync<cr>", "Sync" },
    s = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  l = {
    name = "LSP",
    i = { ":LspInfo<cr>", "Language Servers" },
    m = { ":Mason<cr>", "Manage Language Servers" },

    w = {
      name = "workspace",
      a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Workspace Folder" },
      r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Workspace Folder" },
      l = {
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
        "List Workspace Folders",
      },
    },
  },

  s = {
    name = "search stuff",
    f = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", " files" },
    t = { "<cmd>Telescope live_grep<cr>", " text" },
    b = { "<cmd> Telescope buffers <CR>", " buffers" },
    o = { "<cmd> Telescope oldfiles <CR>", " old files" },
  },

  t = {
    name = "term",
    -- pick a hidden term
    t = { "<cmd> Telescope terms <CR>", "   pick hidde /n term" },
    b = { ":ToggleTerm<cr>", "Split Below" },
    f = { toggle_float, "Floating Terminal" },
  },

  ---HELP STUFF

  h = {
    name = "Help",
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "   show keys" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    p = {
      "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },

    t = { "<cmd> Telescope themes <CR>", "   nvchad themes" },
    ht = { "<cmd> Telescope help_tags <CR>", "  Telescope help page" },
  },
}

-- M.gotocode = {
-- 	g = {
-- 		name = "  goto code",
-- 		t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "  type definition" },
-- 		d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "  definition" },
-- 		D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "  declaration" },
-- 		i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "  implementation" },
-- 		r = { "<cmd>lua vim.lsp.buf.references()<cr>", "  references" },
-- 		k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "  signature" },
-- 		K = { "<cmd>Lspsaga hover_doc<cr>", "   hover" },
--
-- 		-- ["K"] = {
-- 		-- 	function()
-- 		-- 		vim.lsp.buf.hover()
-- 		-- 	end,
-- 		-- 	"   lsp hover",
-- 		-- },
-- 	},
-- }

-- M.extrakeys = function()
-- -- 	map("v", "<", "<gv", { noremap = true, silent = false })
-- -- 	map("v", ">", ">gv", { noremap = true, silent = false })
--
-- -- 	-- map(
-- -- 	-- 	"n",
-- -- 	-- 	"<C-u>",
-- -- 	-- 	"<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>",
-- -- 	-- 	{ noremap = true, silent = true }
-- -- 	-- )
-- -- 	-- map(
-- "n",
-- 		"<C-d>",
-- 		"<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>",
-- 		{ noremap = true, silent = true }
-- 	)
--

M.g = {

  n = {
    -- lsp finder
    h = { "<cmd>Lspsaga lsp_finder<CR>", "which_key_ignore" },

    -- Code action
    ["ca"] = { "<cmd>Lspsaga code_action<CR>", "which_key_ignore" },
  },
}
--
-- map("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { silent = true, noremap = true })
--
-- -- Hover doc
-- -- show hover doc and press twice will jumpto hover window
-- map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
--
-- local action = require("lspsaga.action")
-- -- scroll down hover doc or scroll in definition preview
-- map("n", "<C-f>", function()
-- 	action.smart_scroll_with_saga(1)
-- end, { silent = true })
-- -- scroll up hover doc
-- map("n", "<C-b>", function()
-- 	action.smart_scroll_with_saga(-1)
-- end, { silent = true })
--
-- ---Signature help
-- map("n", "gs", "<Cmd>Lspsaga signature_help<CR>", { silent = true, noremap = true })
--
-- -- Rename with preview and select
-- map("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true, noremap = true })
-- -- close rename win use <C-c> in insert mode or `q` in normal mode or `:q`
--
-- ---Preview definition
-- map("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
--
-- -- Jump and show diagnostics
-- map("n", "gd", "<cmd>Lspsaga preview_definition<CR>", { silent = true })
--
-- map("n", "<leader>cd", require("lspsaga.diagnostic").show_line_diagnostics, { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, noremap = true })
--
-- -- jump diagnostic
-- map("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, noremap = true })
--
-- -- or jump to error
-- map("n", "[E", function()
-- 	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true, noremap = true })
-- map("n", "]E", function()
-- 	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
-- end, { silent = true, noremap = true })
--
-- --Float terminal
-- -- float terminal also you can pass the cli command in open_float_terminal function
-- local term = require("lspsaga.floaterm")
--
-- -- float terminal also you can pass the cli command in open_float_terminal function
-- map("n", "<A-d>", "<cmd>Lspsaga open_floaterm custom_cli_command<CR>", { silent = true, noremap = true })
-- map("t", "<A-d>", "<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>", { silent = true, noremap = true })
--
-- -- Outline
-- -- work fast when lspsaga symbol winbar in_custom = true or enable = true,
-- -- :LSoutlineToggle
-- }
--
-- function M.lspconfig_keys(client, bufnr)
-- 	local map = vim.api.nvim_set_keymap
--
-- 	local m = {
-- 		declaration = "gD",
-- 		definition = "gd",
-- 		hover = "K",
-- 		implementation = "gi",
-- 		signature_help = "gk",
-- 		add_workspace_folder = "<leader>wa",
-- 		remove_workspace_folder = "<leader>wr",
-- 		list_workspace_folders = "<leader>wl",
-- 		type_definition = "<leader>D",
-- 		rename = "<leader>re",
-- 		code_action = "<leader>a",
-- 		references = "gr",
-- 		formatting = "<leader>fm",
-- 		-- diagnostics
-- 		workspace_diagnostics = "<leader>w",
-- 		buffer_diagnostics = "<leader>d",
-- 		-- goto_prev = "[d",
-- 		--[[ 		-- goto_next = "]d", ]]
-- 	}
--
-- 	local buf_k = function(mo, k, c)
-- 		map(mo, k, c, { buffer = bufnr })
-- 	end
--
-- 	-- See `:help vim.lsp.*` for documentation on any of the below functions
-- 	buf_k("n", m.declaration, function()
-- 		vim.lsp.buf.declaration()
-- 	end)
--
-- 	buf_k("n", m.definition, function()
-- 		vim.lsp.buf.definition()
-- 	end)
--
-- 	buf_k("n", m.hover, function()
-- 		vim.lsp.buf.hover()
-- 	end)
-- 	--
-- 	buf_k("n", m.implementation, function()
-- 		vim.lsp.buf.implementation()
-- 	end)
--
-- 	buf_k("n", m.signature_help, function()
-- 		vim.lsp.buf.signature_help()
-- 	end)
--
-- 	buf_k("n", m.type_definition, function()
-- 		vim.lsp.buf.type_definition()
-- 	end)
--
-- 	buf_k("n", m.rename, function()
-- 		vim.lsp.buf.rename()
-- 	end)
--
-- 	buf_k("n", m.code_action, function()
-- 		vim.lsp.buf.code_action()
-- 	end)
--
-- 	buf_k("n", m.references, function()
-- 		require("trouble").open("lsp_references")
-- 	end)
--
-- 	buf_k("n", m.goto_prev, function()
-- 		vim.diagnostic.goto_prev()
-- 	end)
--
-- 	buf_k("n", m.goto_next, function()
-- 		vim.diagnostic.goto_next()
-- 	end)
--
-- 	buf_k("n", m.workspace_diagnostics, function()
-- 		if vim.diagnostic.get()[1] then
-- 			require("trouble").open("workspace_diagnostics")
-- 		else
-- 			vim.notify("No workspace diagnostics found.")
-- 		end
-- 	end)
-- 	--
-- 	buf_k("n", m.buffer_diagnostics, function()
-- 		if vim.diagnostic.get()[1] then
-- 			require("trouble").open("document_diagnostics")
-- 		else
-- 			vim.notify("No docunment diagnostics found.")
-- 		end
-- 	end)
-- 	--
-- 	buf_k("n", m.add_workspace_folder, function()
-- 		vim.lsp.buf.add_workspace_folder()
-- 	end)
--
-- 	buf_k("n", m.remove_workspace_folder, function()
-- 		vim.lsp.buf.remove_workspace_folder()
-- 	end)
--
-- 	buf_k("n", m.list_workspace_folders, function()
-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 	end)
--
-- 	if client.resolved_capabilities.document_formatting then
-- 		buf_k("n", m.formatting, function()
-- 			vim.lsp.buf.formatting_sync()
-- 		end)
-- 		buf_k("v", m.formatting, function()
-- 			vim.lsp.buf.range_formatting()
-- 		end)
-- 	end
-- end
--
--

return M
