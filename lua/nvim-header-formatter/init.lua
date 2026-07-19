local config = require("nvim-header-formatter.config")

local M = {}

-- Strip all leading '#' chars followed by one or more whitespace chars.
-- Lines like "#Foo" (no space after the hashes) are left untouched. Replaces
-- the original daw-based version from ~/.vim/ftplugin/markdown.lua:33-40.
function M.removeExistingMarkdownHeader()
  local line = vim.api.nvim_get_current_line()
  local stripped = line:gsub("^#+%s+", "")
  if stripped ~= line then
    vim.api.nvim_set_current_line(stripped)
  end
end

-- Prepend `level` '#' chars + a space to the current line. Ported verbatim
-- from ~/.vim/ftplugin/markdown.lua:42-46.
function M.addMarkdownHeader(level)
  local line = vim.api.nvim_get_current_line()
  local hash_str = string.rep("#", level)
  vim.api.nvim_set_current_line(hash_str .. " " .. line)
end

-- Wrapper mirroring the original <leader>hN behavior: strip first, then add.
function M.set_header(level)
  M.removeExistingMarkdownHeader()
  M.addMarkdownHeader(level)
end

function M.setup(opts)
  opts = config.merge(opts)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = opts.ft,
    callback = function(args)
      for _, level in ipairs(opts.levels) do
        vim.keymap.set(
          "n",
          opts.keymap_prefix .. level,
          function() M.set_header(level) end,
          {
            buffer = args.buf,
            noremap = true,
            silent = true,
            desc = "Set markdown header level " .. level,
          }
        )
      end
    end,
  })
end

return M
