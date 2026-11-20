-- Removes muzzle flash and hit sparks of bullets

local prune = require("scripts.entities.prune")

local bullet = {}

local names = {
  "firearm-magazine",
  "piercing-rounds-magazine",
  "uranium-rounds-magazine",
}

function bullet.run()
  for _, name in ipairs(names) do
    local proto = data.raw["ammo"] and data.raw["ammo"][name]
    if proto and proto.ammo_type then
      local types = proto.ammo_type
      if types[1] == nil then types = { types } end
      for _, ammo_type in ipairs(types) do
        ammo_type.action = prune.clean(ammo_type.action)
      end
    end
  end
end

return bullet
