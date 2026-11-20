-- Removes explosions of destroyed asteroids and asteroid chunks

local prune = require("scripts.entities.prune")

local asteroid = {}

function asteroid.run()
  for _, proto in pairs(data.raw["asteroid"] or {}) do
    proto.dying_trigger_effect = prune.clean(proto.dying_trigger_effect)
  end
  for _, proto in pairs(data.raw["asteroid-chunk"] or {}) do
    proto.dying_trigger_effect = prune.clean(proto.dying_trigger_effect)
  end
end

return asteroid
