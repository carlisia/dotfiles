local M = {}

M.lsp = {
  --- used by snacks pickers:
  diagnostics = "<leader>lp",
  definition = "<leader>ld",
  implementation = "<leader>li",
  references = "<leader>lr",
  symbols = "<leader>ls",
  ws_symbols = "<leader>lS",
  type_definition = "<leader>lt",
  ---- regular vim lsp
  declaration = "<leader>lc",
  format = "<leader>lf",
  toggle_inlay_hints = "\\y",
  lsp_rename = "<leader>ln",
  signature = "<leader>lg",
  hover = "K",
  toggle_format_os = "\\f", -- on save
  diag_go_next = "]d",
  diag_go_prev = "[d",
  ---
  toggle_test_imp = "\\t",
  toggle_outline = "\\o",
}

M.vim = {
  diagnostics = "<leader>lb",
}

M.go = {
  run = {
    gonvim = {
      rA = { "<cmd>GoCodeAction<cr>", "Code action" },
      ra = { "<cmd>GoAddTag<cr>", "Add struct tags" },
      rb = { "<cmd>GoBuild<cr>", "Build" },
      rC = { "<cmd>GoClearTag<cr>", "Clear all struct tags" },
      rc = { "<cmd>GoCmt<cr>", "Add comment" },
      rd = { "<cmd>GoDoc<cr>", "Show documentation for identifier" },
      re = { "<cmd>Goenum<cr>", "Generate Go enums" },
      rf = { "<cmd>GoFmt<cr>", "Format" },
      rI = { "<cmd>GoImports<cr>", "Manage imports" },
      ri = { "<cmd>GoImplements<cr>", "Find implementations" },
      rj = { "<cmd>GoJson2Struct<cr>", "Convert JSON to Go struct" },
      rL = { "<cmd>GoListImports<cr>", "List imports" },
      rl = { "<cmd>GoCodeLenAct<cr>", "Code lens" },
      rN = { "<cmd>Gomvp<cr>", "Rename Go module" },
      rn = { "<cmd>GoRename<cr>", "Rename identifier under cursor" },
      rr = { "<cmd>GoRun<cr>", "Run" },
      rs = { "<cmd>GoStop<cr>", "Stop task" },
      rT = { "<cmd>GoRmTag<cr>", "Remove struct tags" },
      rv = { "<cmd>GoGenReturn<cr>", "Generate return values" },
      rx = { "<cmd>GoImpl<cr>", "Generate interface implementation" },
    },
  },

  utils = {
    gonvim = {
      uc = { "<cmd>GoCheat<cr>", "Lookup Go cheat sheets" },
      ue = { "<cmd>GoEnv<cr>", "Load environment variables" },
      ug = { "<cmd>GoGet<cr>", "Get packages" },
      ui = { "<cmd>GoInstallBinaries<cr>", "Install binaries" },
      ul = { "<cmd>GoLint<cr>", "Lint" },
      un = { "<cmd>GoNew<cr>", "New file from template" },
      ut = { "<cmd>GoModTidy<cr>", "Mod tidy" },
      uu = { "<cmd>GoUpdateBinaries<cr>", "Update binaries" },
      uV = { "<cmd>Govulncheck<cr>", "Run vulnerability check" },
      uv = { "<cmd>GoVet<cr>", "Run go vet for static analysis" },
    },
  },

  test = {
    gonvim = {
      ta = { "<cmd>GoAddTest<cr>", "Add unit test for function" },
      tc = { "<cmd>GoCoverage<cr>", "Run test coverage" },
      tf = { "<cmd>GoTestFile<cr>", "Test current file" },
      tF = { "<cmd>GoTestFunc<cr>", "Test current function" },
      tm = { "<cmd>GoMockGen<cr>", "Generate Go mocks" },
      ts = { "<cmd>GoTestSum<cr>", "Run tests with summary" },
      tt = { "<cmd>GoTest<cr>", "Run all tests" },
    },
  },

  debug = {
    gonvim = {
      da = { "<cmd>GoBreakToggle<cr>", "Add breakpoint" },
      db = { "<cmd>GoBreakSave<cr>", "Save breakpoints" },
      dc = { "<cmd>GoDbgContinue<cr>", "Continue debugger session" },
      de = { "<cmd>GoDbgStop<cr>", "End debugger session" },
      df = { "<cmd>GoDbgConfig<cr>", "Open debugger config" },
      dj = { "<cmd>GoCreateunch<cr>", "Create launch.json config" },
      dk = { "<cmd>GoDbgKeys<cr>", "Key mappings" },
      dl = { "<cmd>GoBreakLoad<cr>", "Load saved breakpoints" },
      ds = { "<cmd>GoDebug<cr>", "Start debugger" },
      dt = { "<cmd>GoBreakToggle<cr>", "Toggle breakpoint" },
    },
  },
}

return M
