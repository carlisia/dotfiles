return function(builtins)
  local sources = {

    builtins.formatting.goimports,
    builtins.formatting.gofumpt,
    builtins.code_actions.shellcheck,

    -- JS html css stuff
    builtins.formatting.prettierd.with({
      filetypes = { "html", "json", "scss", "css", "javascript", "javascriptreact", "typescript" },
    }),
    -- Lua
    builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
    builtins.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

    -- Shell
    builtins.formatting.shfmt,
    builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
  }

  return sources
end
