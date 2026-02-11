# Vimium Configuration

## Extensions

Browser extension that adds Vim-style keyboard navigation to Chrome/Edge.

- [Install for Chrome](https://chromewebstore.google.com/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb)
- [Install for Edge](https://microsoftedge.microsoft.com/addons/detail/vimium/djmieaghokpkpjfbpelnlkfgfjapaopa)

### Complementary extensions

Replaces the browser's new tab page with a Vimium-friendly one.

- [Install for Chrome](https://microsoftedge.microsoft.com/addons/detail/vimium-new-tab-page/ahmddkokfhbdbmlioknpkipoikcckpah)

- [Install for Edge](https://microsoftedge.microsoft.com/addons/detail/vimium-new-tab-page/ahmddkokfhbdbmlioknpkipoikcckpah)

Edge's default new tab page steals focus from Vimium. This extension replaces it with a blank page so Vimium keypresses work immediately.

- [Install for Edge](https://microsoftedge.microsoft.com/addons/detail/clear-new-tab/ifphophaconbhfmkpdlfldelkjpjmlbj)

## Backup and Restore

`vimium-options.json` contains the full exported config. To restore on a fresh machine:

1. Install Vimium
2. Open Vimium options (click the extension icon, then "Options")
3. Scroll to "Backup and Restore"
4. Click "Import Settings" and select `vimium-options.json`

To update the backup: export from the same section and overwrite the file.

---

## Most Useful Commands (Daily Drivers)

| Key       | Action                        | Notes                               |
| --------- | ----------------------------- | ----------------------------------- |
| `f`       | Click a link (current tab)    | Shows letter hints on every link    |
| `F`       | Click a link (new tab)        | Same hints, opens in background tab |
| `o`       | Open URL / bookmark / history | Fuzzy search (vomnibar)             |
| `O`       | Same, in new tab              |                                     |
| `T`       | Search open tabs              | Like `<leader>fr` in Neovim         |
| `/`       | Find text on page             | Same as Vim                         |
| `n` / `N` | Next / previous match         | Same as Vim                         |
| `yy`      | Copy current URL              | Like Vim yank line                  |
| `p` / `P` | Open clipboard URL            | Current tab / new tab               |
| `gi`      | Focus first text input        | Like Vim's `gi`                     |
| `?`       | Show all keybindings          | Help overlay                        |

## Default Keybindings (Already Match Vim)

These work out of the box with zero config. If you know Vim, you know these.

### Scrolling

| Key         | Action                          | Vim Equivalent             |
| ----------- | ------------------------------- | -------------------------- |
| `j` / `k`   | Scroll down / up                | Identical                  |
| `h` / `l`   | Scroll left / right             | Identical                  |
| `gg` / `G`  | Top / bottom of page            | Identical                  |
| `d` / `u`   | Half page down / up             | `<C-d>` / `<C-u>`          |
| `zH` / `zL` | Scroll all the way left / right | Similar to Vim's `zH`/`zL` |

### Navigation

| Key         | Action                           | Vim Equivalent                      |
| ----------- | -------------------------------- | ----------------------------------- |
| `H` / `L`   | History back / forward           | Standard browser nav                |
| `gu`        | Go up one level in URL           | Like Vim's `gu` (different purpose) |
| `gU`        | Go to URL root                   |                                     |
| `ge` / `gE` | Edit current URL / in new tab    | Like Vim's `ge`                     |
| `]]` / `[[` | Follow next / previous page link | Pagination nav                      |
| `gf` / `gF` | Next frame / main frame          |                                     |

### Find

| Key       | Action                                |
| --------- | ------------------------------------- |
| `/`       | Enter find mode                       |
| `n` / `N` | Next / previous match                 |
| `*` / `#` | Find selected text forward / backward |

### Marks

| Key              | Action       | Vim Equivalent |
| ---------------- | ------------ | -------------- |
| `m` + letter     | Create mark  | Identical      |
| `` ` `` + letter | Jump to mark | Identical      |

Lowercase = local mark (per page), uppercase = global mark (across sites).

### Visual Mode

| Key | Action                          |
| --- | ------------------------------- |
| `v` | Enter visual mode (select text) |
| `V` | Enter visual line mode          |

### Tabs

| Key         | Action                          |
| ----------- | ------------------------------- |
| `J` / `K`   | Previous / next tab             |
| `gt` / `gT` | Next / previous tab (Vim-style) |
| `g0` / `g$` | First / last tab                |
| `^`         | Previously visited tab          |
| `t`         | New tab                         |
| `x`         | Close tab                       |
| `X`         | Restore closed tab              |
| `yt`        | Duplicate tab                   |
| `W`         | Move tab to new window          |
| `<<` / `>>` | Move tab left / right           |
| `<a-p>`     | Pin / unpin tab                 |
| `<a-m>`     | Mute / unmute tab               |

### Vomnibar (Fuzzy Finder)

| Key         | Action                                             |
| ----------- | -------------------------------------------------- |
| `o` / `O`   | Open URL, bookmark, or history (current / new tab) |
| `b` / `B`   | Open bookmark (current / new tab)                  |
| `T`         | Search open tabs                                   |
| `ge` / `gE` | Edit current URL (current / new tab)               |

### Other

| Key       | Action                                |
| --------- | ------------------------------------- |
| `i`       | Enter insert mode (pass keys to page) |
| `r` / `R` | Reload / hard reload                  |
| `gs`      | View page source                      |
| `yf`      | Copy a link URL to clipboard          |
| `<a-f>`   | Open multiple links in new tabs       |

---

## Custom Mappings (Neovim Muscle Memory)

These mirror the Neovim keybindings from this dotfiles repo. Leader key in Neovim is
`<Space>`, and these use `<space>` as a prefix in Vimium to match.

### Tab Management (Buffer Keybindings)

| Vimium       | Action              | Neovim Equivalent                             |
| ------------ | ------------------- | --------------------------------------------- |
| `]b` / `[b`  | Next / previous tab | `]b` / `[b` mini.bracketed buffer nav         |
| `<space>x`   | Close tab           | `<leader>x` close buffer                      |
| `<space>bn`  | New tab             | `<leader>bn` new buffer                       |
| `<space>bt`  | Last visited tab    | `<leader>bt` toggle last two buffers          |
| `<space>bdo` | Close other tabs    | Similar to `<leader>bdo` delete other buffers |
| `<space>bh`  | Move tab left       | `<leader>bh` send buffer left                 |
| `<space>bl`  | Move tab right      | `<leader>bl` send buffer right                |

### Vomnibar (Snacks Picker Keybindings)

| Vimium           | Action              | Neovim Equivalent            |
| ---------------- | ------------------- | ---------------------------- |
| `<space><space>` | Open vomnibar       | `<leader><space>` smart open |
| `<space>ff`      | Open URL in new tab | `<leader>ff` find files      |
| `<space>fr`      | Search open tabs    | `<leader>fr` recent files    |
| `<space>fc`      | Search bookmarks    | `<leader>fc` config files    |
| `<space>fn`      | Edit current URL    | `<leader>fn` rename file     |

### Search

| Vimium      | Action         | Neovim Equivalent      |
| ----------- | -------------- | ---------------------- |
| `<space>fg` | Find on page   | `<leader>fg` grep      |
| `<space>fw` | Copy link text | `<leader>fw` grep word |

### Yank / Paste

| Vimium      | Action                        | Neovim Equivalent      |
| ----------- | ----------------------------- | ---------------------- |
| `<space>fy` | Copy URL                      | `<leader>fy` yank file |
| `<space>fp` | Open clipboard URL            | `<leader>fp` paste     |
| `<space>fP` | Open clipboard URL in new tab |                        |

### Navigation

| Vimium      | Action         | Neovim Equivalent            |
| ----------- | -------------- | ---------------------------- |
| `<space>go` | Go to URL root | `<leader>go` open in browser |
| `<space>gu` | Go up URL path |                              |

### Marks

| Vimium      | Action      | Neovim Equivalent         |
| ----------- | ----------- | ------------------------- |
| `<space>sm` | Create mark | `<leader>sm` marks picker |
| `<space>gm` | Go to mark  |                           |

### Visual Mode

| Vimium      | Action                 |
| ----------- | ---------------------- |
| `<space>sv` | Enter visual mode      |
| `<space>sV` | Enter visual line mode |

### Help

| Vimium     | Action                     | Neovim Equivalent          |
| ---------- | -------------------------- | -------------------------- |
| `<space>h` | Show help                  | `<leader>h` help pages     |
| `<space>k` | Show help                  | `<leader>k` keymaps picker |
| `<space>?` | Open this README on GitHub | Quick reference            |

---

## Custom Search Engines

Type the keyword in the vomnibar (`o` or `O`) followed by your search query.

| Keyword | Target               | Example                     |
| ------- | -------------------- | --------------------------- |
| `g`     | Google               | `g golang context`          |
| `d`     | DuckDuckGo           | `d privacy browser`         |
| `go`    | Go Packages          | `go io Reader`              |
| `gd`    | Go Docs (direct)     | `gd net/http`               |
| `gp`    | Go Playground        |                             |
| `gs`    | Go By Example        | `gs goroutines`             |
| `gh`    | GitHub Repos         | `gh dotfiles neovim`        |
| `gi`    | GitHub Issues        | `gi vimium feature request` |
| `gc`    | GitHub Code          | `gc DiscoveryService`       |
| `gv`    | GitHub (go to repo)  | `gv carlisia/dotfiles`      |
| `tp`    | Teleport Code Search | `tp DiscoveryService`       |
| `ti`    | Teleport Issues      | `ti discovery bug`          |
| `td`    | Teleport Docs        | `td kubernetes access`      |
| `w`     | Wikipedia            | `w vim text editor`         |
| `so`    | StackOverflow        | `so golang context cancel`  |
| `rd`    | Reddit               | `rd neovim plugins`         |
| `yt`    | YouTube              | `yt go concurrency`         |

---

## Excluded URLs

Sites where Vimium is disabled or partially disabled because they have their own
keyboard shortcuts.

| Pattern                          | Keys Excluded   | Reason                                  |
| -------------------------------- | --------------- | --------------------------------------- |
| `https?://mail.google.com/*`     | All             | Gmail shortcuts                         |
| `https?://docs.google.com/*`     | All             | Google Docs shortcuts                   |
| `https?://sheets.google.com/*`   | All             | Google Sheets shortcuts                 |
| `https?://calendar.google.com/*` | All             | Calendar `j`/`k` navigation             |
| `https?://meet.google.com/*`     | All             | Mute/camera shortcuts                   |
| `https?://discord.com/*`         | All             | Discord keybinds                        |
| `https?://app.slack.com/*`       | All             | Slack keybinds                          |
| `https?://www.notion.so/*`       | All             | Notion `/` commands, `@`, `[[`          |
| `https?://github.com/*`          | `j k t s / ? .` | GitHub file finder, search, codespaces  |
| `https?://youtube.com/*`         | `j k f l c m`   | Seek, pause, fullscreen, captions, mute |

---

## Options

Recommended settings in Vimium options:

| Option                                                 | Setting | Why                                                                                         |
| ------------------------------------------------------ | ------- | ------------------------------------------------------------------------------------------- |
| Use smooth scrolling                                   | ON      | Already used to smooth scroll from Neovim                                                   |
| Use link's name and characters for link-hint filtering | ON      | Type the link text to filter instead of random letters — like typing in your Snacks picker  |
| Don't let pages steal the focus on load                | ON      | Prevents Google/Bing from auto-focusing their search box, which eats your Vimium keypresses |
| Hide the HUD in insert mode                            | OFF     | The HUD tells you when you're in insert mode — useful while learning                        |
| Hide update notifications                              | Either  | Personal preference, doesn't matter                                                         |
| Treat find queries as JS regular expressions           | ON      | You think in regex — escape back to plain mode with `\R` if needed                          |
| Ignore keyboard layout                                 | OFF     | Only matters for non-QWERTY layouts                                                         |

The two that make the biggest difference day-to-day are **link-hint filtering** and
**don't let pages steal focus**. The first makes `f` mode feel like a fuzzy finder
instead of a memory game, and the second stops sites from swallowing your keystrokes.

---

## CSS Theme

The CSS in `vimium-options.json` themes the link hints, vomnibar, and HUD to match
the [grokkingtech.io](https://grokkingtech.io/) dark mode palette:

- `#1a1a1d` — dark background
- `#2a2a2d` — lighter gray (selected items, borders)
- `#a83382` — pink/magenta accent (matched text, borders)
- `#5f81ff` — blue (URLs)
- `#dcdcdc` — light text
