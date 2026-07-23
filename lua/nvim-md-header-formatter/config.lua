local M = {}

M.defaults = {
  keymap_prefix = "<leader>h", -- yields <leader>h1 .. <leader>h6
  levels = { 1, 2, 3, 4, 5, 6 },
  ft = { "markdown" },
}

function M.merge(opts)
  opts = opts or {}
  return {
    keymap_prefix = opts.keymap_prefix or M.defaults.keymap_prefix,
    levels = opts.levels or M.defaults.levels,
    ft = opts.ft or M.defaults.ft,
  }
end

return M