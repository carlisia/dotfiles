local M = {}

M.telescope = {
    defaults = {
        path_display = {
            "smart",
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
        },
        file_ignore_patterns = { "node_modules/", ".git/", "%.git/refs", "%.git/logs" },
        },
        mappings = {
            i = { ["<Esc>"] = require("telescope.actions").close },
            n = {
              ["q"] = require("telescope.actions").close,
              ["<Esc>"] = require("telescope.actions").close,
            },
        },
        extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        },
        -- extension_list = { "fzf", "notify", "persisted", "neoclip", "octo" },
        extension_list = { "fzf", "notify" },
}

return M