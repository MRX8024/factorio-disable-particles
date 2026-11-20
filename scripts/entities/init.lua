-- Runs every entity module enabled in the startup settings

local entities = require("scripts.entities.entities")

local init = {}

function init.run()
  for _, e in ipairs(entities) do
    local exists = e.requires == nil or mods[e.requires] ~= nil
    if exists and settings.startup[e.setting].value then
      require("scripts.entities." .. e.name).run()
    end
  end
end

return init
