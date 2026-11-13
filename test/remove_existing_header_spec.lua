local t = require('test.testutil')
local n = require('test.functional.testnvim')()

t.describe('removeExistingMarkdownHeader', function()
  t.before_each(function()
    n.clear()
    n.exec_lua(function()
      vim.opt.runtimepath:append(vim.fn.getcwd())
    end)
  end)

  local cases = {
    { input = '# Foo', expected = 'Foo', desc = 'single-level header' },
    { input = '### Foo', expected = 'Foo', desc = 'multi-level header' },
    { input = '#Foo', expected = '#Foo', desc = 'no space after # is untouched' },
    { input = 'Foo', expected = 'Foo', desc = 'non-header untouched' },
    { input = '#  Foo', expected = 'Foo', desc = 'multiple spaces stripped' },
    { input = '## ', expected = '', desc = 'hashes + trailing space -> empty' },
    { input = '##', expected = '##', desc = 'hashes alone, no whitespace, untouched' },
    { input = '', expected = '', desc = 'empty line untouched' },
  }

  for _, c in ipairs(cases) do
    t.it(c.desc, function()
      n.api.nvim_set_current_line(c.input)
      n.exec_lua(function()
        require('nvim-md-header-formatter').removeExistingMarkdownHeader()
      end)
      t.eq(c.expected, n.api.nvim_get_current_line())
    end)
  end
end)
