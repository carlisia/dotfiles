local M = {}

-- wrapper to use vim.api.nvim_echo
-- table of {string, highlight}
-- e.g echo({{"Hello", "Title"}, {"World"}})
function M.echo(opts)
  if opts == nil or type(opts) ~= "table" then
    return
  end
  vim.api.nvim_echo(opts, false, {})
end

function M.create_dirs()
  local dir = vim.fn.expand "%:p:h"
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

function M.packer_lazy_load(plugin, time)
  vim.defer_fn(function()
    require("packer").loader(plugin)
  end, time or 0)
end

-- https://www.reddit.com/r/neovim/comments/p3b20j/lua_solution_to_writing_a_file_using_sudo
-- execute with sudo
function M.sudo_exec(cmd, print_output)
  local password = vim.fn.inputsecret "Password: "
  if not password or #password == 0 then
    M.echo { { "Invalid password, sudo aborted", "WarningMsg" } }
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print "\r\n"
    M.echo { { out, "ErrorMsg" } }
    return false
  end
  if print_output then
    print("\r\n", out)
  end
  return true
end

-- write to a file using sudo
function M.sudo_write(filepath, tmpfile)
  if not tmpfile then
    tmpfile = vim.fn.tempname()
  end
  if not filepath then
    filepath = vim.fn.expand "%"
  end
  if not filepath or #filepath == 0 then
    M.echo { { "E32: No file name", "ErrorMsg" } }
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if M.sudo_exec(cmd) then
    M.echo { { string.format('\r\n"%s" written', filepath), "Directory" } }
    vim.cmd "e!"
  end
  vim.fn.delete(tmpfile)
end

return M
