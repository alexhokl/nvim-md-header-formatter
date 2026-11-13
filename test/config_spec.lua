local t = require('test.testutil')
local n = require('test.functional.testnvim')()

-- Returns the defaults and the result of config.merge(opts).
local function merge(opts)
  return unpack(n.exec_lua(function(o)
    local config = require('nvim-md-header-formatter.config')
    return { config.defaults, config.merge(o) }
  end, opts))
end

t.describe('config.merge', function()
  t.before_each(function()
    n.clear()
    n.exec_lua(function()
      vim.opt.runtimepath:append(vim.fn.getcwd())
    end)
  end)

  t.it('returns defaults when opts is nil', function()
    local defaults, m = merge(nil)
    t.eq(defaults, m)
  end)

  t.it('overrides keymap_prefix only', function()
    local defaults, m = merge({ keymap_prefix = '<leader>x' })
    t.eq('<leader>x', m.keymap_prefix)
    t.eq(defaults.levels, m.levels)
    t.eq(defaults.ft, m.ft)
  end)

  t.it('overrides levels only', function()
    local defaults, m = merge({ levels = { 2 } })
    t.eq(defaults.keymap_prefix, m.keymap_prefix)
    t.eq({ 2 }, m.levels)
    t.eq(defaults.ft, m.ft)
  end)

  t.it('overrides ft only', function()
    local defaults, m = merge({ ft = { 'markdown', 'markdown.mdx' } })
    t.eq(defaults.keymap_prefix, m.keymap_prefix)
    t.eq(defaults.levels, m.levels)
    t.eq({ 'markdown', 'markdown.mdx' }, m.ft)
  end)
end)
