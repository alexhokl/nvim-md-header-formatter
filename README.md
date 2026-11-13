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
  "alexhokl/nvim-md-header-formatter",
  ft = "markdown",
  opts = {},
}
```

## Setup

```lua
require("nvim-md-header-formatter").setup({
  keymap_prefix = "<leader>h",   -- yields <leader>h1 .. <leader>h6
  levels        = { 1, 2, 3, 4, 5, 6 },
  ft            = { "markdown" },
})
```

All options are optional; the values above are the defaults.

## Tests

Uses the Nvim plugin test harness (`:help dev-test-plugin`). `Makefile` is
a copy of `contrib/plugin_test.mk` from the Neovim repository. On first run,
`make test` downloads the harness modules into `.deps/` (gitignored). Each
test runs against a fresh Nvim.

```
task test
task test-file -- test/set_header_spec.lua
make test NVIM_PRG=/path/to/nvim NVIM_TEST_VERSION=master
```

`NVIM_TEST_VERSION` (default `master`) should match the Nvim under test.
Remove `.deps/` to download the harness again.
