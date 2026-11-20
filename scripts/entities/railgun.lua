-- Removes the muzzle flash and beam smoke of railgun shots
-- The beam itself stays

local prune = require("scripts.entities.prune")

local railgun = {}

local function as_list(v)
  if v == nil then return {} end
  if v[1] == nil then return { v } end
  return v
end

function railgun.run()
  local beam = data.raw["explosion"] and data.raw["explosion"]["railgun-beam"]
  if beam then
    beam.smoke = nil
    beam.smoke_count = 0
  end
  local ammo = data.raw["ammo"] and data.raw["ammo"]["railgun-ammo"]
  if not ammo or not ammo.ammo_type then return end
  for _, ammo_type in ipairs(as_list(ammo.ammo_type)) do
    for _, action in ipairs(as_list(ammo_type.action)) do
      for _, delivery in ipairs(as_list(action.action_delivery)) do
        delivery.source_effects = prune.clean(delivery.source_effects)
      end
    end
  end
end

return railgun
