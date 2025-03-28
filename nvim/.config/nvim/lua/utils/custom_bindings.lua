local M = {}

M.lsp = {
  -- snack pickers: search
  diagnostics = "<leader>lp",
  -- snack pickers: lsp
  declaration = "<leader>lc",
  definition = "<leader>ld",
  implementation = "<leader>li",
  references = "<leader>lr",
  symbols = "<leader>ls",
  type_definition = "<leader>lt",
  ws_symbols = "<leader>lS",
  -- other
  format = "<leader>lf",
  -- toggles
  toggle_format_os = "\\f", -- on save
  toggle_inlay_hints = "\\y",
  toggle_outline = "\\o",
  toggle_test_imp = "\\t",
}

M.vim = {
  code_action = "<leader>la",
  diagnostics_buffer = "<leader>lb",
  hover = "K",
  lsp_rename = "<leader>ln",
  signature = "<leader>lg",

  diag_go_next = "]d",
  diag_go_prev = "[d",
}

M.go = {
  run = {
    gonvim = {
      la = { "<cmd>GoCodeAction<cr>", "Code action" },
      ln = { "<cmd>GoRename<cr>", "Rename identifier under cursor" },

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
      rr = { "<cmd>GoRun<cr>", "Run" },
      rR = {
        function()
          -- Get full path to current file
          local full_path = vim.fn.expand "%:p"
          -- Trim the file path to be relative to root
          local rel_path = vim.fn.fnamemodify(full_path, ":.") -- path relative to cwd
          -- Prompt with the relative path and enable file autocompletion
          local input = vim.fn.input {
            prompt = "Path to file > ",
            default = rel_path,
            completion = "file",
          }
          if input == nil or input == "" then
            return -- escaped or gave empty input
          end
          vim.cmd("GoRun " .. input)
        end,
        "Run...",
      },
    },
  },

  mod = {
    gonvim = {
      mi = { "<cmd>GoModInit<cr>", "go mod init" },
      md = { "<cmd>GoModDnld<cr>", "go mod download" },
      mt = { "<cmd>GoModTidy<cr>", "go mod tidy" },
      mr = { "<cmd>Gomvp<cr>", "go mod rename" },
      mv = { "<cmd>GoModVendor<cr>", "go mod vendor" },
      mw = { "<cmd>GoModWhy<cr>", "go mod why" },
    },
  },

  utils = {
    gonvim = {
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
  },

  test = {
    gonvim = {
      ta = { "<cmd>GoAddTest<cr>", "Add unit test for function" },
      tc = { "<cmd>GoCoverage<cr>", "Run test coverage" },
      tf = { "<cmd>GoTestFile<cr>", "Test current file" },
      tF = { "<cmd>GoTestFunc<cr>", "Test current function" },
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
