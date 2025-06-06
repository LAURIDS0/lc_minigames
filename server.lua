local QBCore = exports['qb-core']:GetCoreObject()

-- Basic server-side setup for lc_minigames wheel UI

-- Event to give player a wheel
RegisterNetEvent('lc_minigames:giveWheel', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    Player.Functions.AddItem('vehicle_wheel', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['vehicle_wheel'], 'add')
end)

-- Add vehicle_wheel item to the shared items if needed
Citizen.CreateThread(function()
    if QBCore.Shared.Items['vehicle_wheel'] == nil then
        QBCore.Shared.Items['vehicle_wheel'] = {
            name = 'vehicle_wheel',
            label = 'Vehicle Wheel',
            weight = 7000,
            type = 'item',
            image = 'vehicle_wheel.png',
            unique = false,
            useable = false,
            shouldClose = false,
            combinable = nil,
            description = 'A wheel removed from a vehicle'
        }
    end
end)
