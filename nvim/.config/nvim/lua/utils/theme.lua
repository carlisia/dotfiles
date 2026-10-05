-- Theme preferences live here, not in chadrc.lua: the NvChad theme picker persists a choice by
-- rewriting every quoted occurrence of the old theme name in chadrc, which would clobber them.
local M = {}

M.default = "bearded-arc"
M.toggle_pair = { "bearded-arc", "one_light" }

-- Loads name and persists it as chadrc's base46.theme, the way NvChad's picker and toggle do.
local function apply(name)
  package.loaded.chadrc = nil
  local saved = require("chadrc").base46.theme
  if saved ~= name then
    require("nvchad.utils").replace_word('theme = "' .. saved .. '"', 'theme = "' .. name .. '"')
  end

  require("nvconfig").base46.theme = name
  require("base46").load_all_highlights()
end

-- base46 themes that ship as a dark = light pair. Where a theme is in both this table and
-- toggle_pair (one_light), toggle_pair wins.
local variants = {
  ["ayu_dark"] = "ayu_light",
  ["catppuccin"] = "catppuccin-latte",
  ["default-dark"] = "default-light",
  ["espresso"] = "espresso-light",
  ["everforest"] = "everforest_light",
  ["flexoki"] = "flexoki-light",
  ["github_dark"] = "github_light",
  ["gruvbox"] = "gruvbox_light",
  ["material-darker"] = "material-lighter",
  ["midnight_breeze"] = "sunrise_breeze",
  ["oceanic-next"] = "oceanic-light",
  ["onedark"] = "one_light",
  ["onenord"] = "onenord_light",
  ["penumbra_dark"] = "penumbra_light",
  ["rosepine"] = "rosepine-dawn",
  ["seoul256_dark"] = "seoul256_light",
  ["solarized_dark"] = "solarized_light",
  ["vscode_dark"] = "vscode_light",
}

local function counterpart(name)
  local pair = M.toggle_pair
  if name == pair[1] then
    return pair[2]
  elseif name == pair[2] then
    return pair[1]
  elseif variants[name] then
    return variants[name]
  end

  for dark, light in pairs(variants) do
    if light == name then
      return dark
    end
  end
end

-- Flips the current theme to its light/dark counterpart. A theme without one stays put.
function M.toggle()
  local current = require("nvconfig").base46.theme
  local other = counterpart(current)
  if not other then
    vim.notify(
      current .. " has no light/dark counterpart; <leader>V resets to " .. M.default,
      vim.log.levels.WARN
    )
    return
  end

  apply(other)
end

function M.reset()
  apply(M.default)
end

return M
