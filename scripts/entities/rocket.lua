-- Removes launch flash, smoke trail, explosions, scorchmarks and
-- tile effects of rockets

local prune = require("scripts.entities.prune")

local rocket = {}

local names = { "rocket", "explosive-rocket" }

function rocket.run()
  for _, name in ipairs(names) do
    local ammo = data.raw["ammo"] and data.raw["ammo"][name]
    if ammo and ammo.ammo_type then
      local types = ammo.ammo_type
      if types[1] == nil then types = { types } end
      for _, ammo_type in ipairs(types) do
        ammo_type.action = prune.clean(ammo_type.action)
      end
    end
    local proto = data.raw["projectile"] and data.raw["projectile"][name]
    if proto then
      proto.action = prune.clean(proto.action)
      proto.smoke = nil
    end
  end
end

return rocket
