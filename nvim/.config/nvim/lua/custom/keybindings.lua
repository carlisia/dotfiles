-- all the plugins which are not dependent on any plugin
local map = function(...)
  vim.keymap.set(...)
end

local M = {}

function M.init()
  -- select all text in a buffer
  map({ "n", "x" }, "<C-a>", "gg0vG$")
  -- save with c-s in all modes
  map({ "n", "x", "i" }, "<C-s>", "<Cmd>:update<CR>")
  map("n", "<leader><leader>q", "<Cmd>:qall<CR>")
  -- Reselect visual selection after indenting
  map("v", "<", "<gv")
  map("v", ">", ">gv")
  -- do not select the new line on y
  map("n", "Y", "y$")
  map("x", "Y", "<Esc>y$gv")
  -- Keep matches center screen when cycling with n|N
  map("n", "n", "nzzzv")
  map("n", "N", "Nzzzv")
  -- swap ; with :
  map({ "n", "o", "x" }, ";", ":")
  -- use H for start of line and L for end of line
  map({ "n", "o", "x" }, "H", "0")
  map({ "n", "o", "x" }, "L", "$")

  -- restore my laptop numpad home, end, page up and page down behaviour
  map({ "", "!", "l", "t" }, "", "<Home>")
  map({ "", "!", "l", "t" }, "", "<End>")
  map({ "", "!", "l", "t" }, "", "<PageUP>")
  map({ "", "!", "l", "t" }, "", "<PageDown>")
  map({ "", "!", "l", "t" }, "", "k")
  map({ "", "!", "l", "t" }, "", "j")
  map({ "", "!", "l", "t" }, "", "h")
  map({ "", "!", "l", "t" }, "", "l")

  -- escape from terminal mode
  map("t", "<esc>", [[<C-\><C-n>]])
  map("t", "jk", [[<C-\><C-n>]])
  map("t", "kj", [[<C-\><C-n>]])
  -- move between windows
  map("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
  map("t", "<c-j>", [[<Cmd>wincmd j<CR>]])
  map("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
  map("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

  -- cycle between split windows using Alt+w
  map({ "n", "t", "i" }, "<a-w>", [[<C-\><C-n><C-w>W]])

  map("n", "<leader>m", "<Cmd>:Notifications<CR>")

  map({ "n" }, "<Leader>z", function()
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", direction = "float" })
    return lazygit:toggle()
  end)

  map("n", "<leader>o", "<Cmd>:AerialToggle<CR>")

  -- use <C-\> to toggle the search highlight
  vim.cmd([[nnoremap <silent> <C-\> :if (&hlsearch == 1) \| set nohlsearch \| else \| set hlsearch \| endif<CR>]])

  -- use <enter> to search for the current word (very much like *) but without the cursor jumping
  vim.cmd(
    [[nnoremap <silent> <CR> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<CR> ]) end, }a]]
  )
end

function M.bufdelete()
  -- close buffer
  map({ "n", "x" }, "<leader>x", function()
    require("bufdelete").bufdelete(0, true)
  end)
end

function M.bufferline()
  map("n", "<tab>", "<Cmd>:BufferLineCycleNext<CR>")
  map("n", "<s-tab>", "<Cmd>:BufferLineCyclePrev<CR>")
end

function M.lspconfig(client, bufnr)
  local m = {
    declaration = "gD",
    hover = "K",
    implementation = "gi",
    signature_help = "gk",
    add_workspace_folder = "<leader>wa",
    remove_workspace_folder = "<leader>wr",
    list_workspace_folders = "<leader>wl",
    type_definition = "td",
    rename = "<leader>re",
    code_action = "<leader>ca",
    references = "gr",
    formatting = "<leader>fm",
    -- diagnostics
    workspace_diagnostics = "<leader>q",
    buffer_diagnostics = "ge",
    goto_prev = "[d",
    goto_next = "]d",
  }
  local buf_k = function(mo, k, c)
    map(mo, k, c, { buffer = bufnr })
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_k("n", m.declaration, function()
    vim.lsp.buf.declaration()
  end)

  map("n", "gd", "<Cmd>:Lspsaga lsp_finder<CR>")

  buf_k("n", m.hover, "<Cmd>Lspsaga hover_doc<CR>")
  -- scroll down hover doc or scroll in definition preview
  buf_k("n", "<C-f>", function()
    require("lspsaga.action").smart_scroll_with_saga(1)
  end)
  -- scroll up hover doc
  buf_k("n", "<C-b>", function()
    require("lspsaga.action").smart_scroll_with_saga(-1)
  end)

  buf_k("n", m.implementation, vim.lsp.buf.implementation)

  buf_k("n", m.signature_help, function()
    require("lspsaga.signaturehelp").signature_help()
  end)

  buf_k("n", m.type_definition, vim.lsp.buf.type_definition)

  buf_k("n", m.rename, vim.lsp.buf.rename)

  buf_k("n", m.code_action, [[:Lspsaga code_action<CR>]])

  buf_k("v", "<leader>ca", [[:Lspsaga range_code_action<CR>]])

  buf_k("n", m.references, function()
    require("trouble").open("lsp_references")
  end)

  buf_k("n", m.goto_prev, function()
    require("lspsaga.diagnostic").goto_prev()
  end)

  buf_k("n", m.goto_next, function()
    require("lspsaga.diagnostic").goto_next()
  end)

  buf_k("n", m.workspace_diagnostics, function()
    if vim.diagnostic.get()[1] then
      require("trouble").open("workspace_diagnostics")
    else
      vim.notify("No diagnostics found.")
    end
  end)

  buf_k("n", m.buffer_diagnostics, function()
    if vim.diagnostic.get(bufnr)[1] then
      require("trouble").open("document_diagnostics")
    else
      vim.notify("No diagnostics found.")
    end
  end)

  buf_k("n", m.add_workspace_folder, vim.lsp.buf.add_workspace_folder)

  buf_k("n", m.remove_workspace_folder, vim.lsp.buf.remove_workspace_folder)

  buf_k("n", m.list_workspace_folders, function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end)

  require("custom.utils").setup_lsp_format(client, bufnr)
end

function M.neotree()
  map({ "n" }, "<C-n>", "<Cmd>Neotree toggle<CR>")
end

function M.neogen()
  map({ "n" }, "<Leader>d", function()
    require("neogen").generate()
  end)
  map({ "i" }, "<C-f>", function()
    require("neogen").jump_next()
  end)
  map({ "i" }, "<C-b>", function()
    require("neogen").jump_prev()
  end)
end

function M.searchbox()
  map("n", "<leader>s", function()
    require("searchbox").replace({ confirm = "menu", default_value = vim.fn.expand("<cword>") })
  end)

  map("x", "<leader>s", function()
    -- grab the old value of a register
    local a_content = vim.fn.getreg("a")
    -- copy the current visual selection to "a" register
    vim.cmd('noau normal! "ay"')
    -- grab content
    local content, v_mode = vim.fn.getreg("a"), false
    -- restore the "a" register
    vim.fn.setreg("a", a_content)

    if content:match("\n") then
      content, v_mode = "", true
    end
    require("searchbox").replace({ confirm = "menu", default_value = content, visual_mode = v_mode })
  end)
end

function M.spectre()
  map("n", "<leader>fr", function()
    require("spectre").open()
  end, { desc = "Find and Replace [ Folder wide ]" })
end

function M.toggleterm()
  map({ "n", "i", "t" }, "<a-t>", function()
    require("toggleterm").toggle(0, nil, nil, "horizontal")
  end)
  map({ "n", "i", "t" }, "<a-v>", function()
    require("toggleterm").toggle(0, nil, nil, "vertical")
  end)
  map({ "n", "i", "t" }, "<a-f>", function()
    require("toggleterm").toggle(0, nil, nil, "float")
  end)
end

return M