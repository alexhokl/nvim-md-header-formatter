local t = require('test.testutil')
local n = require('test.functional.testnvim')()

t.describe('dot repeat', function()
  t.before_each(function()
    n.clear()
    n.exec_lua(function()
      vim.opt.runtimepath:append(vim.fn.getcwd())
      require('nvim-md-header-formatter').setup({ keymap_prefix = ',' })
      vim.bo.filetype = 'markdown'
    end)
  end)

  t.it("repeats the last header-level change on another line via '.'", function()
    n.api.nvim_buf_set_lines(0, 0, -1, false, { 'foo', 'bar' })

    n.feed('gg,3')
    t.eq('### foo', n.api.nvim_buf_get_lines(0, 0, 1, false)[1])

    n.feed('j.')
    t.eq('### bar', n.api.nvim_buf_get_lines(0, 1, 2, false)[1])
  end)
end)
