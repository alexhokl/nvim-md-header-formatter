local t = require('test.testutil')
local n = require('test.functional.testnvim')()

-- Runs setup(opts), opens a buffer with `filetype` and returns which of
-- `lhs_list` are mapped in normal mode in that buffer.
local function mapped(opts, filetype, lhs_list)
  return n.exec_lua(function(o, ft, lhss)
    require('nvim-md-header-formatter').setup(o)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = ft
    local result = {}
    for _, lhs in ipairs(lhss) do
      result[lhs] = vim.fn.maparg(lhs, 'n', false, true).buffer == 1
    end
    return result
  end, opts, filetype, lhs_list)
end

local function prefixed(prefix)
  local list = {}
  for i = 1, 6 do
    list[#list + 1] = prefix .. i
  end
  return list
end

t.describe('setup', function()
  t.before_each(function()
    n.clear()
    n.exec_lua(function()
      vim.opt.runtimepath:append(vim.fn.getcwd())
    end)
  end)

  t.it('registers default keymaps on markdown buffers', function()
    for lhs, ok in pairs(mapped({}, 'markdown', prefixed('<leader>h'))) do
      t.eq(true, ok, 'expected ' .. lhs .. ' to be mapped')
    end
  end)

  t.it('does not register keymaps on non-markdown buffers', function()
    for lhs, ok in pairs(mapped({}, 'text', prefixed('<leader>h'))) do
      t.eq(false, ok, 'expected ' .. lhs .. ' to NOT be mapped')
    end
  end)

  t.it('honors custom keymap_prefix', function()
    local lhs_list = vim.list_extend(prefixed('<leader>x'), prefixed('<leader>h'))
    local result = mapped({ keymap_prefix = '<leader>x' }, 'markdown', lhs_list)
    for i = 1, 6 do
      t.eq(true, result['<leader>x' .. i])
      t.eq(false, result['<leader>h' .. i])
    end
  end)

  t.it('honors custom levels', function()
    t.eq({
      ['<leader>h1'] = false,
      ['<leader>h2'] = true,
      ['<leader>h3'] = false,
      ['<leader>h4'] = true,
      ['<leader>h5'] = false,
      ['<leader>h6'] = false,
    }, mapped({ levels = { 2, 4 } }, 'markdown', prefixed('<leader>h')))
  end)

  t.it('honors custom ft list', function()
    local opts = { ft = { 'markdown', 'markdown.mdx' } }
    t.eq({ ['<leader>h1'] = true }, mapped(opts, 'markdown', { '<leader>h1' }))
    t.eq({ ['<leader>h1'] = true }, mapped(opts, 'markdown.mdx', { '<leader>h1' }))
    t.eq({ ['<leader>h1'] = false }, mapped(opts, 'text', { '<leader>h1' }))
  end)
end)
