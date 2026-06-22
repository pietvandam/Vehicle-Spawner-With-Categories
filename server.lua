RegisterNetEvent("garage:spawnVehicle", function(model)
    local src = source
    TriggerClientEvent("garage:spawnVehicleClient", src, model)
end)