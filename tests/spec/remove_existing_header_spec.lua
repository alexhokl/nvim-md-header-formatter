local M = require("nvim-header-formatter")

describe("removeExistingMarkdownHeader", function()
  local buf

  before_each(function()
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
  end)

  after_each(function()
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end)

  local cases = {
    { input = "# Foo",       expected = "Foo",   desc = "single-level header" },
    { input = "### Foo",      expected = "Foo",   desc = "multi-level header" },
    { input = "#Foo",         expected = "#Foo",  desc = "no space after # is untouched" },
    { input = "Foo",          expected = "Foo",   desc = "non-header untouched" },
    { input = "#  Foo",       expected = "Foo",   desc = "multiple spaces stripped" },
    { input = "## ",          expected = "",      desc = "hashes + trailing space -> empty" },
    { input = "##",           expected = "##",    desc = "hashes alone, no whitespace, untouched" },
    { input = "",             expected = "",      desc = "empty line untouched" },
  }

  for _, c in ipairs(cases) do
    it(c.desc, function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { c.input })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      M.removeExistingMarkdownHeader()
      assert.are.same(c.expected, vim.api.nvim_get_current_line())
    end)
  end
end)