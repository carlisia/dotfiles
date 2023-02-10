return function(builtins)
  local sources = {

    builtins.formatting.goimports,
    builtins.formatting.gofumpt,

    builtins.formatting.prettierd.with({
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "yaml",
      "markdown",
      "graphql",
      "handlebars",
    }),
    builtins.formatting.shfmt.with({ extra_args = { "-i", "2", "-ci" } }),
    builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),

    builtins.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),
    builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
    builtins.diagnostics.yamllint,
    builtins.diagnostics.actionlint,
    builtins.diagnostics.alex,

    builtins.code_actions.gitsigns,
    builtins.code_actions.shellcheck,
  }
  return sources
end
