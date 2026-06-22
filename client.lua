local QBCore = exports['qb-core']:GetCoreObject()

-- =========================
-- SPAWNPOINT LOGIC
-- =========================
local function GetClosestSpawn(coords)
    local closest, dist = nil, 999999

    for _, v in pairs(Config.spawnPoints) do
        local d = #(coords - vector3(v.x, v.y, v.z))
        if d < dist then
            dist = d
            closest = v
        end
    end

    return closest
end

-- =========================
-- SPAWN EFFECT
-- =========================
local function SpawnEffect()
    DoScreenFadeOut(300)
    Wait(300)
    DoScreenFadeIn(300)
end

-- =========================
-- SPAWN VEHICLE
-- =========================
local function SpawnVehicle(model)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    local spawn = GetClosestSpawn(coords)
    if not spawn then return end

    SpawnEffect()

    local hash = joaat(model)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(0)
    end

    local veh = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, spawn.w, true, false)

    SetPedIntoVehicle(ped, veh, -1)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleNumberPlateText(veh, "GARAGE")
end

-- =========================
-- MAIN MENU
-- =========================
local function OpenGarage()

    local options = {}

    for cat, data in pairs(Config.categories or {}) do
        options[#options+1] = {
            title = data.label,
            icon = "car",
            onSelect = function()

                local vehOptions = {}

                for _, v in pairs(data.vehicles or {}) do
                    vehOptions[#vehOptions+1] = {
                        title = v.label,
                        icon = "car",
                        onSelect = function()
                            TriggerServerEvent("garage:spawnVehicle", v.model)
                        end
                    }
                end

                lib.registerContext({
                    id = "garage_"..cat,
                    title = data.label,
                    options = vehOptions
                })

                lib.showContext("garage_"..cat)
            end
        }
    end

    lib.registerContext({
        id = "garage_main",
        title = "Voertuig Garage",
        options = options
    })

    lib.showContext("garage_main")
end

-- =========================
-- SEARCH
-- =========================
local function OpenSearch()

    local input = lib.inputDialog("Zoek voertuig", {
        { type = "input", label = "Naam of model", required = true }
    })

    if not input then return end

    local query = string.lower(input[1])
    local results = {}

    for _, cat in pairs(Config.categories or {}) do
        for _, v in pairs(cat.vehicles or {}) do
            if string.find(string.lower(v.label), query) or string.find(string.lower(v.model), query) then
                results[#results+1] = {
                    title = v.label,
                    icon = "car",
                    onSelect = function()
                        TriggerServerEvent("garage:spawnVehicle", v.model)
                    end
                }
            end
        end
    end

    lib.registerContext({
        id = "garage_search",
        title = "Zoekresultaten",
        options = results
    })

    lib.showContext("garage_search")
end

-- =========================
-- MAIN UI
-- =========================
local function OpenMain()

    lib.registerContext({
        id = "garage_menu",
        title = "Garage Menu",
        options = {
            {
                title = "Voertuigen",
                icon = "car",
                onSelect = OpenGarage
            },
            {
                title = "Zoeken",
                icon = "magnifying-glass",
                onSelect = OpenSearch
            }
        }
    })

    lib.showContext("garage_menu")
end

-- =========================
-- COMMAND
-- =========================
RegisterCommand(Config.command, function()
    OpenMain()
end)

-- =========================
-- SPAWN EVENT
-- =========================
RegisterNetEvent("garage:spawnVehicleClient", function(model)
    SpawnVehicle(model)
end)