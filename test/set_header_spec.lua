local t = require('test.testutil')
local n = require('test.functional.testnvim')()

t.describe('set_header', function()
  t.before_each(function()
    n.clear()
    n.exec_lua(function()
      vim.opt.runtimepath:append(vim.fn.getcwd())
    end)
  end)

  local cases = {
    { input = '# Foo', level = 3, expected = '### Foo', desc = 'strip then add (reset level)' },
    { input = 'Foo', level = 2, expected = '## Foo', desc = 'no existing header' },
    { input = '### Foo', level = 1, expected = '# Foo', desc = 'demote header' },
    { input = '#Foo', level = 2, expected = '## #Foo', desc = 'no-space line untouched, header added' },
  }

  for _, c in ipairs(cases) do
    t.it(c.desc, function()
      n.api.nvim_set_current_line(c.input)
      n.exec_lua(function(level)
        require('nvim-md-header-formatter').set_header(level)
      end, c.level)
      t.eq(c.expected, n.api.nvim_get_current_line())
    end)
  end
end)
