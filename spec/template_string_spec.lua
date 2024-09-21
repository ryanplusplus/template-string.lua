describe('template_string', function()
  local ts = require 'template_string'

  it('should return the same string if no placeholders are present', function()
    assert.are.equal('hello, world', ts('hello, world'))
  end)

  it('should replace placeholders with values', function()
    assert.are.equal('hello, world', ts('hello, ${name}', { name = 'world' }))
  end)

  it('should replace placeholders with evaluated expressions', function()
    assert.are.equal('hello, WORLD', ts('hello, ${name:upper()}', { name = 'world' }))
  end)

  it("should evaluate expressions using the caller's locals when no environment is provided", function()
    local name = 'world'
    assert.are.equal('hello, world', ts('hello, ${name}'))
  end)

  it("should evaluate expressions using the caller's upvalues when no environment is provided", function()
    local name = 'world'
      (function()
        local x = name
        assert.are.equal('hello, world', ts('hello, ${name}'))
      end)()
  end)

  it("should evaluate expressions using the caller's globals when no environment is provided", function()
    _G.global_name = 'world'
    assert.are.equal('hello, world', ts('hello, ${global_name}'))
  end)

  it('should give a helpful error when an expression cannot be evaluated', function()
    assert.has_error(function()
      ts('hello, ${name .. "!"}')
    end, "attempt to concatenate a nil value (global 'name')")
  end)
end)
