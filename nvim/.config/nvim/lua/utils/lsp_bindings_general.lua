local M = {}

M.vim = {
  { "<leader>la", "vim.lsp.buf.code_action", "Code action" },
  { "K", "vim.lsp.buf.hover", "Hover" },
  { "<leader>ln", "require('nvchad.lsp.renamer')", "Rename identifier under cursor" },
  { "<leader>lg", "vim.lsp.buf.signature_help", "Signature" },
  { "]d", "vim.diagnostic.goto_next", "Next diagnostic" },
  { "[d", "vim.diagnostic.goto_prev", "Prev diagnostic" },
}

M.lsp_keys = {
  toggle_format_os = "\\f",
  toggle_inlay_hints = "\\y",
  toggle_outline = "\\o",
  diagnostics = "<leader>lp",
  declaration = "<leader>lc",
  definition = "<leader>ld",
  implementation = "<leader>li",
  references = "<leader>lr",
  symbols = "<leader>ls",
  type_definition = "<leader>lt",
  ws_symbols = "<leader>lS",
}

local toggles = require "utils.toggles"
local _, snacks = pcall(require, "snacks")
M.lsp = {
  toggle_outline = { "<cmd>Outline!<cr>", "Toggle 'outline'" },
  toggle_format_os = { toggles.autoformat_on_save, "Toggle 'format on save'" },
  diagnostics = {
    function()
      snacks.picker.diagnostics()
    end,
    "Code diagnostics",
  },
  declaration = {
    function()
      snacks.picker.lsp_declarations()
    end,
    "Declaration",
  },
  definition = {
    function()
      snacks.picker.lsp_definitions()
    end,
    "Definition",
  },
  implementation = {
    function()
      snacks.picker.lsp_implementations()
    end,
    "Implementation",
  },
  references = {
    function()
      snacks.picker.lsp_references()
    end,
    "References",
  },
  symbols = {
    function()
      snacks.picker.lsp_symbols()
    end,
    "Symbols",
  },
  type_definition = {
    function()
      snacks.picker.lsp_type_definitions()
    end,
    "Type definition",
  },
  ws_symbols = {
    function()
      snacks.picker.lsp_workspace_symbols()
    end,
    "Workspace symbols",
  },
}

M.go_keys = {
  -- debug
  da = "\\g",
  db = "<leader>db",
  dc = "<leader>dc",
  de = "<leader>de",
  df = "<leader>df",
  dj = "<leader>dj",
  dk = "<leader>dk",
  dl = "<leader>dl",
  ds = "<leader>ds",
  dt = "<leader>dt",

  -- language
  la = "<leader>la",
  li = "<leader>li",
  ln = "<leader>ln",
  lo = "<leader>lo",
  ly = "\\y",

  -- run
  ra = "<leader>ra",
  rb = "<leader>rb",
  rC = "<leader>rC",
  rc = "<leader>rc",
  rd = "<leader>rd",
  re = "<leader>re",
  rf = "<leader>rf",
  rI = "<leader>rI",
  rj = "<leader>rj",
  rL = "<leader>rL",
  rl = "<leader>rl",
  rr = "<leader>rr",
  rR = "<leader>rR",

  -- go mod
  md = "<leader>md",
  mi = "<leader>mi",
  mr = "<leader>mr",
  mt = "<leader>mt",
  mv = "<leader>mv",
  mw = "<leader>mw",

  -- tests
  ta = "<leader>ta",
  tc = "<leader>tc",
  ti = "\\t",
  tf = "<leader>tf",
  tF = "<leader>tF",
  tm = "<leader>tm",
  ts = "<leader>ts",
  tt = "<leader>tt",

  -- utilities
  uc = "<leader>uc",
  ue = "<leader>ue",
  ug = "<leader>ug",
  ui = "<leader>ui",
  ul = "<leader>ul",
  un = "<leader>un",
  uu = "<leader>uu",
  uV = "<leader>uV",
  uv = "<leader>uv",
}

M.go = {
  gonvim = {
    da = { "<cmd>GoBreakToggle<cr>", "Toggle 'breakpoint'" },
    db = { "<cmd>GoBreakSave<cr>", "Save breakpoints" },
    dc = { "<cmd>GoDbgContinue<cr>", "Continue debugger session" },
    de = { "<cmd>GoDbgStop<cr>", "End debugger session" },
    df = { "<cmd>GoDbgConfig<cr>", "Open debugger config" },
    dj = { "<cmd>GoCreateunch<cr>", "Create launch.json config" },
    dk = { "<cmd>GoDbgKeys<cr>", "Key mappings" },
    dl = { "<cmd>GoBreakLoad<cr>", "Load saved breakpoints" },
    ds = { "<cmd>GoDebug<cr>", "Start debugger" },

    la = { "<cmd>GoCodeAction<cr>", "Go: Code action" },
    li = { "<cmd>GoImplements<cr>", "Go: Find implementations" },
    ln = { "<cmd>GoRename<cr>", "Go: Rename identifier under cursor" },
    lo = { "<cmd>GoPkgOutline<cr>", "Go: Outline" },
    ly = { "<cmd>GoToggleInlay<cr><cmd>redrawstatus<cr>", "Go: Toggle 'inlay hints'" },

    md = { "<cmd>GoModDnld<cr>", "go mod download" },
    mi = { "<cmd>GoModInit<cr>", "go mod init" },
    mr = { "<cmd>Gomvp<cr>", "go mod rename" },
    mt = { "<cmd>GoModTidy<cr>", "go mod tidy" },
    mv = { "<cmd>GoModVendor<cr>", "go mod vendor" },
    mw = { "<cmd>GoModWhy<cr>", "go mod why" },

    ra = { "<cmd>GoAddTag<cr>", "Add struct tags" },
    rb = { "<cmd>GoBuild<cr>", "Build" },
    rC = { "<cmd>GoClearTag<cr>", "Clear all struct tags" },
    rc = { "<cmd>GoCmt<cr>", "Add comment" },
    rd = { "<cmd>GoDoc<cr>", "Show documentation for identifier" },
    re = { "<cmd>Goenum<cr>", "Generate Go enums" },
    rf = { "<cmd>GoFmt<cr>", "Format" },
    rI = { "<cmd>GoImports<cr>", "Manage imports" },
    rj = { "<cmd>GoJson2Struct<cr>", "Convert JSON to Go struct" },
    rL = { "<cmd>GoListImports<cr>", "List imports" },
    rl = { "<cmd>GoCodeLenAct<cr>", "Code lens" },
    rr = { "<cmd>GoRun<cr>", "Run" },
    rR = {
      function()
        local full_path = vim.fn.expand "%:p"
        local rel_path = vim.fn.fnamemodify(full_path, ":.")
        local input = vim.fn.input {
          prompt = "Path to file > ",
          default = rel_path,
          completion = "file",
        }
        if input == nil or input == "" then
          return
        end
        vim.cmd("GoRun " .. input)
      end,
      "Run...",
    },

    ta = { "<cmd>GoAddTest<cr>", "Add unit test for function" },
    tc = { "<cmd>GoCoverage<cr>", "Run test coverage" },
    ti = { "<cmd>GoAlt<cr>", "Toggle 'test/implementation'" },
    tF = { "<cmd>GoTestFunc<cr>", "Test current function" },
    tf = { "<cmd>GoTestFile<cr>", "Test current file" },
    tm = { "<cmd>GoMockGen<cr>", "Generate mocks" },
    ts = { "<cmd>GoTestSum<cr>", "Run tests with summary" },
    tt = {
      function()
        local choices = {
          { label = "Run All Tests", cmd = "GoTestSum --format dots" },
          { label = "Run with test names", cmd = "GoTestSum --format testname" },
          { label = "Run with package names", cmd = "GoTestSum --format pkgname" },
        }
        vim.ui.select(choices, {
          prompt = "Choose test option:",
          format_item = function(item)
            return item.label
          end,
        }, function(choice)
          if not choice then
            return
          end
          vim.cmd(choice.cmd)
        end)
      end,
      "Run Go tests",
    },

    uc = { "<cmd>GoCheat<cr>", "Cheat sheet" },
    ue = { "<cmd>GoEnv<cr>", "Load environment variables" },
    ug = { "<cmd>GoGet<cr>", "Get packages" },
    ui = { "<cmd>GoInstallBinaries<cr>", "Install binaries" },
    ul = { "<cmd>GoLint<cr>", "Lint" },
    un = { "<cmd>GoNew<cr>", "New file from template" },
    uu = { "<cmd>GoUpdateBinaries<cr>", "Update binaries" },
    uV = { "<cmd>Govulncheck<cr>", "Run vulnerability check" },
    uv = { "<cmd>GoVet<cr>", "Run go vet for static analysis" },
  },
}

return M
