  local M = {}
-- M is a table and it typically means that it is a module
--M.setup = function (opts)
--  print(opts)
--end
--Functions we need:
--vim.keymap.set() --> Create a keymap
--vim.api.nvim_get_keymap
-- In lua, the only thing that are falsy are false and nil
-- Zero is truthy, empty table, empty table is truthy
local find_mapping = function(maps, lhs)
  --pairs
  --iterates over EVERY key in a table
  --order is not guaratenteed
  --
  --ipairs
  --iterates over ONLY numeric keys in a table
  --order IS guaratenteed
  for _, value in ipairs(maps) do
    if value.lhs == lhs then
      return value
    end
  end
end

M._stack = {}

M.push = function(name, mode, mappings)
  local maps = vim.api.nvim_get_keymap(mode)
  local existing_maps = {}
  for lhs, rhs in pairs(mappings) do
    print("Searching for LHS: ", lhs)
    local existing = find_mapping(maps, lhs)
    if existing then
        existing_maps[lhs] = existing
    end
  end
  P(existing_maps)
  M._stack[name] = M._stack[name] or {}
  M._stack[name][mode] = {
      existing = existing_maps,
      mappings = mappings,
    }

  for lhs, rhs in pairs(mappings) do
    vim.keymap.set(mode, lhs, rhs)
  end
end

M.pop = function(name, mode)
    local state = M._stack[name][mode]
    M._stack[name][mode] = nil

    for lhs in pairs(state.mappings) do
      if state.existing[lhs] then
        --Handle mappings that exist
        local og_mapping = state.existing[lhs]
        vim.keymap.set(mode, lhs, og_mapping.rhs)
      else
        --Handle mappings that don't exist
        vim.keymap.del(mode, lhs)
      end
    end
end

M.push("debug_mode", "n", {
  [" sf"] = ":lua print('Hello')<CR>",
  [" sz"] = ":lua print('Goodbye')<CR>",
})
return M

