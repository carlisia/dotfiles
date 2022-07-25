return {
   ["max397574/better-escape.nvim"] = {
      config = function()
         require("better_escape").setup {
            mapping = { "jk", "JK", "Jk" },
         }
      end,
   },
   ["stevearc/dressing.nvim"] = {
      opt = true,
      setup = function()
         require("custom.utils").packer_lazy_load("dressing.nvim", 500)
      end,
   },
   ["kevinhwang91/nvim-bqf"] = { ft = "qf" },

   ["folke/trouble.nvim"] = {
      module = "trouble",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
         require("trouble").setup {
            auto_close = true, -- automatically close the list when you have no diagnostics
            use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
         }
      end,
   },
   ["neovim/nvim-lspconfig"] = {
      opt = true,
      module = "lspconfig",
      config = function()
         require "custom.plugins.lspconfig"
      end,
      setup = function()
         require("custom.utils").packer_lazy_load "nvim-lspconfig"
         -- reload the current file so lsp actually starts for it
         vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
         end, 0)
      end,
   },
   ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,
   },
   ["folke/lua-dev.nvim"] = { ft = "lua" },
   ["nacro90/numb.nvim"] = {
      event = "CmdlineEnter",
      config = function()
         require("numb").setup()
      end,
   },
   ["nvim-telescope/telescope-fzf-native.nvim"] = {
      run = "make",
      after = "telescope.nvim",
      config = function()
         require("telescope").load_extension "fzf"
      end,
      setup = function()
         require("custom.utils").packer_lazy_load("telescope.nvim", 1000)
      end,
   },
   ["hrsh7th/cmp-cmdline"] = {
      after = "nvim-cmp",
      config = function()
         local cmp = require "cmp"
         cmp.setup.cmdline("/", {
            sources = {
               { name = "buffer" },
            },
            mapping = cmp.mapping.preset.cmdline {},
         })
         cmp.setup.cmdline(":", {
            sources = cmp.config.sources({
               { name = "path" },
            }, {
               { name = "cmdline" },
            }),
            mapping = cmp.mapping.preset.cmdline {},
         })
      end,
      setup = function()
         require("custom.utils").packer_lazy_load "nvim-cmp"
      end,
   },
   ["ggandor/lightspeed.nvim"] = {
      opt = true,
      config = function()
         require("lightspeed").setup {
            ignore_case = true,
            repeat_ft_with_target_char = true,
         }
      end,
      setup = function()
         require("custom.utils").packer_lazy_load "lightspeed.nvim"
      end,
   },
   ["VonHeikemen/searchbox.nvim"] = {
      module = "searchbox",
      command = "SearchBox",
      requires = {
         { "MunifTanjim/nui.nvim" },
      },
      setup = function()
         require("custom.mappings").searchbox()
      end,
   },
   ["windwp/nvim-spectre"] = {
      module = "spectre",
      command = "FindReplace",
      config = function()
         require("spectre").setup {
            color_devicons = true,
            open_cmd = "new",
            is_insert_mode = true,
         }
      end,
      setup = function()
         vim.cmd 'silent! command FindReplace lua require("spectre").open({})'
      end,
   },
}
