return function(builtins)
  local sources = {

    -- builtins.formatting.goimports,
    -- builtins.formatting.gofumpt,

    builtins.formatting.prettierd.with({ "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown", "graphql", "handlebars" }),
    builtins.formatting.shfmt,
    builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),

    builtins.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),
    builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
    builtins.diagnostics.yamllint,
  }
  return sources
end