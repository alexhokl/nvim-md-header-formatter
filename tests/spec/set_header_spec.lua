local M = require("nvim-header-formatter")

describe("set_header", function()
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
    { input = "# Foo",    level = 3, expected = "### Foo",  desc = "strip then add (reset level)" },
    { input = "Foo",      level = 2, expected = "## Foo",    desc = "no existing header" },
    { input = "### Foo",  level = 1, expected = "# Foo",     desc = "demote header" },
    { input = "#Foo",     level = 2, expected = "## #Foo",   desc = "no-space line untouched, header added" },
  }

  for _, c in ipairs(cases) do
    it(c.desc, function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { c.input })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      M.set_header(c.level)
      assert.are.same(c.expected, vim.api.nvim_get_current_line())
    end)
  end
end)