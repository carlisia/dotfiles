local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	b.formatting.prettierd.with({
		filetypes = { "markdown", "html", "json" },
	}),

	b.formatting.stylua,
	b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
}

null_ls.setup({
	debug = true,
	sources = sources,
})
