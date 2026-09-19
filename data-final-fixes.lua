local particles = require("scripts.particles")
local prune = require("scripts.prune")

local mode = settings.startup["dp-mode"].value

local targets = {}
for _, p in ipairs(particles) do
  local exists = p.requires == nil or mods[p.requires] ~= nil
  local checked = settings.startup[p.setting].value
  if exists and (mode == "all" or (mode == "custom" and checked)) then
    targets[p.name] = true
  end
end

if next(targets) ~= nil then
  prune.run(targets)
end
