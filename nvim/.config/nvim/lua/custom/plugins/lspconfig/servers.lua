local servers = {

  --- example ---
  -- ["bashls"] = { config = function or table , disable_format = true or false }
  -- no need to specify config and disable_format is no changes are required
  ["bashls"] = {},
  ["gopls"] = {},
  ["jsonls"] = {},
  ["dockerls"] = {},
  ["marksman"] = {},
  ["yamlls"] = {},
}

--- These below needs some extra stuff done do their default config

-- lua
servers["sumneko_lua"] = {
  config = function()
    local lua_lsp_config = {
      cmd = { "lua-language-server" },
      flags = { debounce_text_changes = 300 },
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          runtime = { version = "LuaJIT" },
          workspace = { maxPreload = 10000, preloadFileSize = 5000 },
          telemetry = { enable = false },
        },
      },
    }

    local neovim_config_dir = vim.fn.resolve(vim.fn.stdpath("config"))
    local neovim_local_dir = vim.fn.resolve(vim.fn.stdpath("data"))
    local cwd = vim.fn.getcwd()
    -- is this file in the config directory?
    -- if neovim_parent_dir == cwd then
    if string.match(cwd, neovim_config_dir) or string.match(cwd, neovim_local_dir) then
      local ok, lua_dev = pcall(require, "lua-dev")
      if ok then
        local luadev = lua_dev.setup({
          library = {
            vimruntime = true, -- runtime path
            types = true,
            plugins = false,
            -- you can also specify the list of plugins to make available as a workspace library
            -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
          },
          runtime_path = true, -- enable this to get completion in require strings. Slow!
        })
        lua_lsp_config = vim.tbl_deep_extend("force", luadev, lua_lsp_config) or {}
      end
    end
    return lua_lsp_config
  end,
  disable_format = true,
}

-- golang
servers["gopls"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

servers["marksman"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

servers["yamlls"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

servers["bashls"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

return servers
