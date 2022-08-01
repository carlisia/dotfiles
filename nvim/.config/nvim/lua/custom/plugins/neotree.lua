-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup {
  sort_case_insensitive = true, -- used when sorting files and directories in the tree
  default_component_configs = { indent = { padding = 2 } },
  window = {
    position = "left",
    width = 25,
    mappings = {
      ["o"] = "open",
      ["s"] = "open_split",
      ["v"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["z"] = "close_all_nodes",
      ["Z"] = "expand_all_nodes",
      ["a"] = { "add", config = { show_path = "relative" } },
      ["A"] = { "add_directory", config = { show_path = "relative" } },
      ["r"] = { "rename", config = { show_path = "relative" } },
      ["y"] = { "copy_to_clipboard", config = { show_path = "relative" } },
      ["x"] = { "cut_to_clipboard", config = { show_path = "relative" } },
      ["p"] = { "paste_from_clipboard", config = { show_path = "relative" } },
    },
  },
  filesystem = {
    filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false, hide_hidden = false },
    follow_current_file = true,
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    window = { mappings = { ["b"] = "navigate_up", ["O"] = "set_root" } },
  },
}

vim.cmd [[nnoremap <c-n> <cmd>Neotree toggle<cr>]]
vim.cmd [[nnoremap \ <cmd>Neotree toggle<cr>]]
