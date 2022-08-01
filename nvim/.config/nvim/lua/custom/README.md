## Custom folder used with NVCHAD

### Some notes

- `init.lua` - To add neovim options or any thing

- `plugins/lspconfig/servers.lua` - All [LSP servers](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) should be configured here.

- `plugins/null-ls/builtins.lua` - All [null-ls builtins](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md) should be configured here

- If no manual configuration is needed for LSP servers or null-ls, then `:Mason` command can be used to add new LSP servers, formatters and linters.

- `plugins/init.lua` - To add new plugins
