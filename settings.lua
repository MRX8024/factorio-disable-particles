local particles = require("scripts.particles")

local settings_list = {
  {
    type = "string-setting",
    name = "dp-mode",
    setting_type = "startup",
    default_value = "custom",
    allowed_values = { "custom", "all", "none" },
    order = "a01",
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

data:extend(settings_list)
