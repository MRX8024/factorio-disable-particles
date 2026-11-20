local particles = require("scripts.particles.particles")
local entities = require("scripts.entities.entities")

local settings_list = {
  {
    type = "string-setting",
    name = "dp-mode",
    setting_type = "startup",
    default_value = "custom",
    allowed_values = { "custom", "all", "none" },
    order = "b01",
  },
}

for _, p in ipairs(particles) do
  settings_list[#settings_list + 1] = {
    type = "bool-setting",
    name = p.setting,
    localised_name = p.name,
    setting_type = "startup",
    default_value = true,
    order = p.order,
    hidden = p.requires ~= nil and mods[p.requires] == nil,
  }
end

for _, e in ipairs(entities) do
  settings_list[#settings_list + 1] = {
    type = "bool-setting",
    name = e.setting,
    setting_type = "startup",
    default_value = true,
    order = e.order,
    hidden = e.requires ~= nil and mods[e.requires] == nil,
  }
end

data:extend(settings_list)
