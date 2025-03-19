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
}

M.vim = {
  diagnostics = "<leader>lb",
}
--[[
GoInstallBinaries
GoUpdateBinaries 
GoInstallBinary
GoUpdateBinary
GoCoverage
GoImports
GoBuild
GoRun
GoStop


GoTest
GoTestSum
GoTestFile
GoTestFunc
GoTestFunc
GoAddTest
GoMockGen 

GoDebug
GoDbgConfig 
GoDbgKeys 
GoDbgStop  
GoDbgContinue 
GoCreateLaunch 
GoBreakToggle 
GoBreakSave 
GoBreakLoad 
GoEnv 
GoAlt 


GoFmt
GoLint
GoRename
GoAddTag 
GoRmTag
GoClearTag 
GoJson2Struct
GoPkgOutline
GoImplements 
GoImpl
GoToggleInlay
GoGenReturn

Goenum
GoNew 

Govulncheck




GoVet
GoDoc 
GoCheat
GoGet 

Gomvp 


    map({ "n" }, "<leader>ca", function()vim.cmd "GoCodeAction"end, silent_bufnr "Code Action")
    map({ "n" }, "<leader>cl", function()vim.cmd "GoCodeLenAct"end)


]]

M.go = {
  run = {
    gonvim = {
      rI = { "<cmd>GoImports<cr>", "Manage imports" },
      rb = { "<cmd>GoBuild<cr>", "Build Go project" },
      rr = { "<cmd>GoRun<cr>", "Run Go program" },
      rs = { "<cmd>GoStop<cr>", "Stop running Go task" },
      rf = { "<cmd>GoFmt<cr>", "Format Go code" },
      rc = { "<cmd>GoCheat<cr>", "Lookup Go cheat sheets" },
      rg = { "<cmd>GoGet<cr>", "Fetch a Go package" },
      rl = { "<cmd>GoLint<cr>", "Run Go linters" },
      rn = { "<cmd>GoRename<cr>", "Rename identifier under cursor" },
      rN = { "<cmd>Gomvp<cr>", "Rename Go module" },
      ra = { "<cmd>GoAddTag<cr>", "Add struct tags" },
      rT = { "<cmd>GoRmTag<cr>", "Remove struct tags" },
      rC = { "<cmd>GoClearTag<cr>", "Clear all struct tags" },
      rA = { "<cmd>GoAlt<cr>", "Toggle between test and implementation" },
      rd = { "<cmd>GoDoc<cr>", "Show documentation for identifier" },
      rm = { "<cmd>GoMockGen<cr>", "Generate Go mocks" },
      rp = { "<cmd>GoPkgOutline<cr>", "Show package symbols" },
      ri = { "<cmd>GoImplements<cr>", "Find implementations" },
      rx = { "<cmd>GoImpl<cr>", "Generate interface implementation" },
      rj = { "<cmd>GoJson2Struct<cr>", "Convert JSON to Go struct" },
      rv = { "<cmd>GoGenReturn<cr>", "Generate return values" },
      re = { "<cmd>Goenum<cr>", "Generate Go enums" },
    },
  },

  utils = {
    gonvim = {
      uv = { "<cmd>GoVet<cr>", "Run go vet for static analysis" },
      ue = { "<cmd>GoEnv<cr>", "Load environment variables" },
      uV = { "<cmd>Govulncheck<cr>", "Run vulnerability check" },
      ui = { "<cmd>GoInstallBinaries<cr>", "Install all dependent tools" },
      uu = { "<cmd>GoUpdateBinaries<cr>", "Update all installed tools" },
      un = { "<cmd>GoNew<cr>", "Create a new Go file from template" },
    },
  },

  test = {
    gonvim = {
      tf = { "<cmd>GoTestFunc<cr>", "Test the current function" },
      tu = { "<cmd>GoAddTest<cr>", "Add unit test for function" },
      tt = { "<cmd>GoTestFile<cr>", "Test the current file" },
      ta = { "<cmd>GoTest<cr>", "Run all tests" },
      tc = { "<cmd>GoCoverage<cr>", "Run and highlight test coverage" },
      ts = { "<cmd>GoTestSum<cr>", "Run Go tests with summary" },
    },
  },

  debug = {
    gonvim = {
      da = { "<cmd>GoBreakToggle<cr>", "Add breakpoint" },
      ds = { "<cmd>GoDebug<cr>", "Start debugger" },
      dc = { "<cmd>GoDbgConfig<cr>", "Open debugger config" },
      dk = { "<cmd>GoDbgKeys<cr>", "Show debugger key mappings" },
      de = { "<cmd>GoDbgStop<cr>", "Stop debugger session" },
      dp = { "<cmd>GoDbgContinue<cr>", "Continue debugger session" },
      dj = { "<cmd>GoCreateLaunch<cr>", "Create launch.json config" },
      dt = { "<cmd>GoBreakToggle<cr>", "Toggle breakpoint" },
      db = { "<cmd>GoBreakSave<cr>", "Save breakpoints" },
      dl = { "<cmd>GoBreakLoad<cr>", "Load saved breakpoints" },
    },
  },
}

return M
