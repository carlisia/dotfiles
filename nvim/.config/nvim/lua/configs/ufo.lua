local M = {}

M.keys = {
  {
    "zR",
    function()
      require("ufo").openAllFolds()
    end,
    desc = "+++Open all folds",
  },
  {
    "zM",
    function()
      require("ufo").closeAllFolds()
    end,
    desc = "---Close all folds",
  },
  {
    "zI",
    function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end,
    desc = "---Peek inside a fold",
  },
}

M.config = {
  provider_selector = function(_, filetype, buftype)
    -- Special buffers (Outline sidebar, floats): the treesitter provider throws
    -- UfoFallbackException on buftype=nofile, and nothing after it catches that.
    if buftype ~= "" then
      return ""
    end
    -- Markdown: use vim's built-in fold expr (set by g.markdown_folding)
    if filetype == "markdown" then
      return ""
    end
    -- Everything else: lsp -> treesitter -> indent. A two-provider list ends at
    -- treesitter, which throws UfoFallbackException when the language has no
    -- parser (e.g. lean); the chain from nvim-ufo's doc/example.lua catches it.
    return function(bufnr)
      local function fallback(err, provider)
        if type(err) == "string" and err:match "UfoFallbackException" then
          return require("ufo").getFolds(bufnr, provider)
        end
        return require("promise").reject(err)
      end
      return require("ufo")
        .getFolds(bufnr, "lsp")
        :catch(function(err)
          return fallback(err, "treesitter")
        end)
        :catch(function(err)
          return fallback(err, "indent")
        end)
    end
  end,
  close_fold_kinds_for_ft = {
    default = {},
  },
  preview = {
    win_config = {
      border = { "", "─", "", "", "", "─", "", "" },
      winhighlight = "Normal:Folded",
      winblend = 0,
    },
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>",
      jumpTop = "[",
      jumpBot = "]",
    },
  },
}

return M
