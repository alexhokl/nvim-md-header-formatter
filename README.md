# nvim-md-header-formatter

A tiny Neovim plugin to set or replace Markdown header levels on the current line.

## Features

- `<leader>h1` … `<leader>h6` — set the current line's header level.
- Setting a level first strips any existing leading `#` header, then prepends
  the new level. So `<leader>h3` on `# Foo` produces `### Foo`.
- Lines like `#Foo` (no whitespace after the hashes) are **not** treated as
  headers and are left untouched.
- Strictly opt-in: no auto-setup. You must call `setup()` from your config.

## Installation

### lazy.nvim

```lua
{
  "alexhokl/nvim-header-formatter",
  ft = "markdown",
  opts = {},
}
```

## Setup

```lua
require("nvim-header-formatter").setup({
  keymap_prefix = "<leader>h",   -- yields <leader>h1 .. <leader>h6
  levels        = { 1, 2, 3, 4, 5, 6 },
  ft            = { "markdown" },
})
```

All options are optional; the values above are the defaults.

## Tests

Uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) as a test
harness. Plenary is vendored on first run under `tests/.deps/` (which is
gitignored), so the test suite is self-contained and CI-friendly.

```
task test
```
