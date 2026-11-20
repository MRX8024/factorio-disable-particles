-- Items inserted out of a space platform vanish after one tick
-- instead of flying away for 25 seconds

local ejected_item = {}

function ejected_item.run()
  local constants = data.raw["utility-constants"]["default"]
  constants.ejected_item_lifetime = 1
end

return ejected_item
