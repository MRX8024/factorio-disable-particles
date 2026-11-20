-- Removes visual effects of the car entity

local car = {}

-- All of them are optional in the car prototype
local fields = {
  "dying_explosion",
  "dying_trigger_effect",
  "corpse",
  "damaged_trigger_effect",
}

function car.run()
  local proto = data.raw["car"] and data.raw["car"]["car"]
  if not proto then return end
  for _, field in ipairs(fields) do
    proto[field] = nil
  end
end

return car
