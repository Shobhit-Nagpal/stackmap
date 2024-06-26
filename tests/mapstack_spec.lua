local find_map = function(maps, lhs)
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return map
    end
  end
end

describe("mapstack", function()
  it("can be required", function()
    reqiure("stackmap")
  end)

  it("can push a single mapping", function()
    local rhs = ":lua print('This is from a test')<CR>" 
    require("stackmap").push("test1", "n", {
      asdf = rhs
    })
    local maps = vim.api.nvim_get_keymap("n")
    local found = find_map(maps, "asdf")
    assert.are.same(rhs, found.rhs)
  end)

  it("can push multiple mappings", function()
    local rhs = ":lua print('This is from a test')<CR>" 
    require("stackmap").push("test1", "n", {
      ["asdf_1"] = rhs .. "1",
      ["asdf_2"] = rhs .. "2",
    })
    local maps = vim.api.nvim_get_keymap("n")
    local found_1 = find_map(maps, "asdf_1")
    assert.are.same(rhs .. "1", found_1.rhs)

    local found_2 = find_map(maps, "asdf_2")
    assert.are.same(rhs .. "2", found_2.rhs)
  end)
end
)
