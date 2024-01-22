RegisterServerEvent("jg-vehicleindicators:server:set-state", function(netId, value)
  local vehicle = NetworkGetEntityFromNetworkId(netId)
  Entity(vehicle).state.indicate = value
end)