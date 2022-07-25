return {
  ["neovim/nvim-lspconfig"] = {
    opt = true,
    module = "lspconfig",
    config = function()
      require("custom.plugins.lspconfig")
    end,
    setup = function()
      require("custom.utils").packer_lazy_load("nvim-lspconfig")
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
        vim.cmd('if &ft == "packer" | echo "" | else | silent! e %')
      end, 0)
    end,
  },
	-- ["neovim/nvim-lspconfig"] = {
 --    module = "lspconfig",
 --    opt = true,
 --    after = "nvim-treesitter",
	-- 	config = function()
	-- 		require("plugins.configs.lspconfig")
	-- 		require("custom.plugins.lspconfig")
	-- 	end,
	-- },

    ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.null-ls").setup()
    end,
  },

	["ggandor/lightspeed.nvim"] = {
    module = "lightspeed",
		opt = true,
		config = function()
			require("lightspeed").setup({
				ignore_case = true,
				repeat_ft_with_target_char = true,
			})
		end,
	},
	-- ["yamatsum/nvim-cursorline"] = {},
	-- ["itspriddle/vim-marked"] = {},
	-- ["mg979/vim-visual-multi"] =  {},
}

