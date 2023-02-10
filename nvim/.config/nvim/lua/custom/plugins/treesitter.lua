local load_hl = require("base46").load_highlight
load_hl "treesitter"

local setup = function()
  local present, ts_config = pcall(require, "nvim-treesitter.configs")

  if not present then
    return
  end

  local default = {
    ensure_installed = {
      "go",
      "json",
      "toml",
      "markdown",
      "c",
      "bash",
      "lua",
      "norg",
      "yaml",
      "vim",
    },
    -- autopairs = { enable = true },
    -- context_commentstring = { enable = true },
    highlight = { enable = true, use_languagetree = true },
    indent = { enable = true },
    matchup = { enable = true },
    tree_docs = { enable = true },
  }

  ts_config.setup(default)
end

-- do not load if filetype not set
if vim.bo.filetype ~= "" then
  local chars = vim.fn.wordcount()["chars"]
  -- do not load treesitterif file is bigger than 500 kb
  if chars < 500000 then
    -- do not lazy load if less than 100kb
    if chars < 100000 then
      setup()
    else
      vim.defer_fn(function()
        setup()
      end, 0)
    end
  end
end

require("custom.autocmds").treesitter()
