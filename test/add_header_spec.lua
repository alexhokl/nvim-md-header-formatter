local t = require('test.testutil')
local n = require('test.functional.testnvim')()

t.describe('addMarkdownHeader', function()
  t.before_each(function()
    n.clear()
    n.exec_lua(function()
      vim.opt.runtimepath:append(vim.fn.getcwd())
    end)
  end)

  local cases = {
    { input = 'Foo', level = 1, expected = '# Foo', desc = 'level 1' },
    { input = 'Foo', level = 3, expected = '### Foo', desc = 'level 3' },
    { input = 'Bar', level = 6, expected = '###### Bar', desc = 'level 6' },
    { input = '', level = 2, expected = '## ', desc = 'empty line' },
  }

  for _, c in ipairs(cases) do
    t.it(c.desc, function()
      n.api.nvim_set_current_line(c.input)
      n.exec_lua(function(level)
        require('nvim-md-header-formatter').addMarkdownHeader(level)
      end, c.level)
      t.eq(c.expected, n.api.nvim_get_current_line())
    end)
  end
end)
