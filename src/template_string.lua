local function default_env()
  local caller = debug.getinfo(3, 'f').func
  local caller_env
  local env = {}

  for i = 1, math.huge do
    local k, v = debug.getupvalue(caller, i)
    if not k then break end
    if k == '_ENV' then
      caller_env = v
    else
      env[k] = v
    end
  end

  for i = 1, math.huge do
    local k, v = debug.getlocal(3, i)
    if not k then break end
    env[k] = v
  end

  return setmetatable(env, { __index = caller_env })
end

return function(s, env)
  env = env or default_env()

  return s:gsub('%$(%b{})', function(w)
    return assert(load('return ' .. w:sub(2, -2), nil, nil, env))()
  end)
end
