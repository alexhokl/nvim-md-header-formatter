local M = require("nvim-header-formatter")

local function expand(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

local function has_keymap(buf, lhs)
  local expanded = expand(lhs)
  for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
    if m.lhs == expanded then
      return true
    end
  end
  return false
end

local function with_buf(filetype, fn)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].filetype = filetype
  vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
  fn(buf)
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

describe("setup", function()
  after_each(function()
    pcall(vim.api.nvim_clear_autocmds, { event = "FileType" })
  end)

  it("registers default keymaps on markdown buffers", function()
    M.setup({})
    with_buf("markdown", function(buf)
      for i = 1, 6 do
        assert.is_true(has_keymap(buf, "<leader>h" .. i),
          "expected <leader>h" .. i .. " to be mapped")
      end
    end)
  end)

  it("does not register keymaps on non-markdown buffers", function()
    M.setup({})
    with_buf("text", function(buf)
      for i = 1, 6 do
        assert.is_false(has_keymap(buf, "<leader>h" .. i),
          "expected <leader>h" .. i .. " to NOT be mapped")
      end
    end)
  end)

  it("honors custom keymap_prefix", function()
    M.setup({ keymap_prefix = "<leader>x" })
    with_buf("markdown", function(buf)
      for i = 1, 6 do
        assert.is_true(has_keymap(buf, "<leader>x" .. i))
        assert.is_false(has_keymap(buf, "<leader>h" .. i))
      end
    end)
  end)

  it("honors custom levels", function()
    M.setup({ levels = { 2, 4 } })
    with_buf("markdown", function(buf)
      assert.is_true(has_keymap(buf, "<leader>h2"))
      assert.is_true(has_keymap(buf, "<leader>h4"))
      assert.is_false(has_keymap(buf, "<leader>h1"))
      assert.is_false(has_keymap(buf, "<leader>h3"))
      assert.is_false(has_keymap(buf, "<leader>h5"))
      assert.is_false(has_keymap(buf, "<leader>h6"))
    end)
  end)

  it("honors custom ft list", function()
    M.setup({ ft = { "markdown", "markdown.mdx" } })
    with_buf("markdown", function(buf)
      assert.is_true(has_keymap(buf, "<leader>h1"))
    end)
    with_buf("markdown.mdx", function(buf)
      assert.is_true(has_keymap(buf, "<leader>h1"))
    end)
    with_buf("text", function(buf)
      assert.is_false(has_keymap(buf, "<leader>h1"))
    end)
  end)
end)