-- Entity modules in this folder, one startup checkbox each
--   name     - module file and setting suffix
--   requires - mod that must be active for the entity to exist
local entities = {
  { name = "car" },
  { name = "rocket" },
  { name = "bullet" },
  { name = "railgun",      requires = "space-age" },
  { name = "asteroid",     requires = "space-age" },
  { name = "ejected-item", requires = "space-age" },
}

for i, e in ipairs(entities) do
  e.setting = "dp-entity-" .. e.name
  e.order = string.format("a%03d", i)
end

return entities
