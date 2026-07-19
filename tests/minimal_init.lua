-- Minimal init for headless test runs. Plenary is vendored under
-- tests/.deps/plenary.nvim (bootstrapped by tests/run_tests.sh).
local repo_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
local plenary_path = repo_root .. "/tests/.deps/plenary.nvim"

if vim.fn.isdirectory(plenary_path) == 0 then
  error(
    "plenary.nvim not found at " .. plenary_path
      .. ". Run `task test` (which bootstraps it) instead of invoking nvim directly.",
    0
  )
end

vim.opt.rtp:prepend(plenary_path)
vim.opt.rtp:prepend(repo_root)

require("plenary")