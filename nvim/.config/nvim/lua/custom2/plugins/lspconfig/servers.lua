local servers = {
  --- example ---
  -- ["bashls"] = { config = function or table , disable_format = true or false }
  -- no need to specify config and disable_format is no changes are required
  ["bashls"] = {},
  ["gopls"] = {},
  ["jsonls"] = {},
  ["dockerls"] = {},
  ["marksman"] = {},
}

servers["gopls"] = {
  config = function()
    return {}
  end,
  disable_format = true,
}

return servers
