-- Removes purely visual trigger items from a trigger tree

local prune = {}

-- These only spawn graphics
local visual_types = {
  ["create-explosion"] = true,
  ["create-particle"] = true,
  ["create-trivial-smoke"] = true,
  ["invoke-tile-trigger"] = true,
}

-- Classes that create-entity may spawn only for visuals
local visual_classes = { "explosion", "corpse", "particle-source" }

local function is_visual(v)
  if type(v) ~= "table" or type(v.type) ~= "string" then return false end
  if visual_types[v.type] then return true end
  if v.type == "create-entity" then
    for _, class in ipairs(visual_classes) do
      if data.raw[class] and data.raw[class][v.entity_name] then
        return true
      end
    end
  end
  return false
end

-- Returns the cleaned value, nil when nothing is left
function prune.clean(t)
  if type(t) ~= "table" then return t end
  if is_visual(t) then return nil end
  local n = #t
  if n > 0 then
    local kept = {}
    for i = 1, n do
      local v = prune.clean(t[i])
      if v ~= nil then kept[#kept + 1] = v end
    end
    if #kept == 0 then return nil end
    for i = 1, n do t[i] = kept[i] end
  end
  for k, v in pairs(t) do
    if type(k) ~= "number" and type(v) == "table" then
      t[k] = prune.clean(v)
    end
  end
  return t
end

return prune
