local M = require("nvim-header-formatter")

local function expand(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

local function feedkeys(s)
  vim.api.nvim_feedkeys(expand(s), "x", false)
end

local function with_markdown_buf(fn)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
  fn(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

describe("dot repeat", function()
  after_each(function()
    pcall(vim.api.nvim_clear_autocmds, { event = "FileType" })
  end)

  it("repeats the last header-level change on another line via '.'", function()
    M.setup({ keymap_prefix = "," })
    with_markdown_buf(function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "foo", "bar" })
      vim.api.nvim_win_set_cursor(0, { 1, 0 })

      feedkeys(",3")
      vim.wait(10)
      assert.are.same("### foo", vim.api.nvim_buf_get_lines(0, 0, 1, false)[1])

      vim.api.nvim_win_set_cursor(0, { 2, 0 })
      feedkeys(".")
      vim.wait(10)
      assert.are.same("### bar", vim.api.nvim_buf_get_lines(0, 1, 2, false)[1])
    end)
  end)
end)