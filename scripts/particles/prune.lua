-- Strips every reference to the given particles from data.raw

local prune = {}

function prune.run(targets)
  local removed = 0
  local sources = {}
  for name, proto in pairs(data.raw["particle-source"] or {}) do
    if targets[proto.particle] then
      sources[name] = true
    end
  end
  local function is_target(v)
    if type(v) ~= "table" then return false end
    if v.type == "create-particle" then
      return targets[v.particle_name] == true
    end
    if v.type == "create-entity" then
      return sources[v.entity_name] == true
    end
    return false
  end
  local function note(where, name)
    removed = removed + 1
    -- log("removed " .. name .. " from " .. where)
  end
  local visited = {}
  local function prune(t, where)
    if visited[t] then return false end
    visited[t] = true
    local n = #t
    local was_array = n > 0
    if was_array then
      local kept = {}
      for i = 1, n do
        local v = t[i]
        if is_target(v) then
          note(where, v.particle_name or v.entity_name)
        elseif type(v) == "table" then
          local had_effect = v.effect ~= nil
          local emptied = prune(v, where .. "[" .. i .. "]")
          if not emptied and not (had_effect and v.effect == nil) then
            kept[#kept + 1] = v
          end
        else
          kept[#kept + 1] = v
        end
      end
      for i = 1, n do t[i] = nil end
      for i, v in ipairs(kept) do t[i] = v end
    end
    local zero_prefixes = {}
    for k, v in pairs(t) do
      if type(k) ~= "number" then
        if type(v) == "table" then
          local is_tree_gen = k == "leaf_generation" or k == "branch_generation"
          if is_target(v) and is_tree_gen then
            zero_prefixes[#zero_prefixes + 1] = k == "leaf_generation"
              and "leaves_when_" or "branches_when_"
            note(where .. "." .. k, v.particle_name)
          elseif is_target(v) then
            note(where .. "." .. k, v.particle_name or v.entity_name)
            t[k] = nil
          elseif k == "shell_particle" and targets[v.name] then
            note(where .. "." .. k, v.name)
            t[k] = nil
          elseif prune(v, where .. "." .. k) then
            t[k] = nil
          end
        elseif type(v) == "string" and targets[v]
          and (k == "mining_particle" or k == "particle_name") then
          note(where .. "." .. k, v)
          t[k] = nil
        end
      end
    end
    for _, prefix in ipairs(zero_prefixes) do
      for _, suffix in ipairs({
        "damaged", "destroyed", "mined_manually", "mined_automatically",
      }) do
        t[prefix .. suffix] = 0
      end
    end
    return was_array and next(t) == nil
  end
  for class, protos in pairs(data.raw) do
    if class ~= "optimized-particle" then
      for name, proto in pairs(protos) do
        prune(proto, class .. "/" .. name)
      end
    end
  end
  -- Fallback for particles created at runtime in LuaSurface.create_particle()
  local missing = {}
  for name in pairs(targets) do
    local p = data.raw["optimized-particle"][name]
    if p then
      p.life_time = 2
      p.fade_away_duration = nil
      p.regular_trigger_effect = nil
      p.regular_trigger_effect_frequency = nil
      p.ended_in_water_trigger_effect = nil
      p.ended_on_ground_trigger_effect = nil
      p.pictures = nil
      p.shadows = nil
    else
      missing[#missing + 1] = name
    end
  end
  log("removed " .. removed .. " particle references")
  if #missing > 0 then
    log("unknown particle names: " .. table.concat(missing, ", "))
  end
end

return prune
