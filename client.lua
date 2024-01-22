local function isIndicating(vehicle, type)
  if not Entity(vehicle).state.indicate then return false end
  local state = Entity(vehicle).state.indicate

  if state[1] and state[2] and type == "hazards" then return true end
  if state[1] and not state[2] and type == "right" then return true end
  if not state[1] and state[2] and type == "left" then return true end

  return false
end

local function indicate(type)
  local ped = PlayerPedId()
  if not IsPedInAnyVehicle(ped) then return false end
  local vehicle = GetVehiclePedIsIn(ped)
  
  local value = {}
  if type == "left" and not isIndicating(vehicle, "left") then value = {false, true}
  elseif type == "right" and not isIndicating(vehicle, "right") then value = {true, false}
  elseif type == "hazards" and not isIndicating(vehicle, "hazards") then value = {true, true} 
  else value = {false, false} end

  TriggerServerEvent("jg-vehicleindicators:server:set-state", VehToNet(vehicle), value)
end

AddStateBagChangeHandler("indicate", nil, function(bagName, key, data)
  local entity = GetEntityFromStateBagName(bagName)
  if entity == 0 then return end
  for i, status in ipairs(data) do
    SetVehicleIndicatorLights(entity, i - 1, status)
  end
end)

RegisterCommand("indicate_left", function() indicate("left") end)
RegisterKeyMapping('indicate_left', 'Vehicle indicate left', 'keyboard', 'LEFT')

RegisterCommand("indicate_right", function() indicate("right") end)
RegisterKeyMapping('indicate_right', 'Vehicle indicate right', 'keyboard', 'RIGHT')

RegisterCommand("hazards", function() indicate("hazards") end)
RegisterKeyMapping('hazards', 'Vehicle hazards', 'keyboard', 'UP')