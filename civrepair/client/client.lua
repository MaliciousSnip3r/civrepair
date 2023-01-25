

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if ESX == nil then
            ESX = exports["es_extended"]:getSharedObject()
        end
        Citizen.Wait(0)
    end
end)

local vehicle = nil


RegisterNetEvent('repairVehicle')
AddEventHandler('repairVehicle', function()
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    vehicle = ESX.Game.GetClosestVehicle()
    if vehicle ~= nil then
        local vehicleCoords = GetEntityCoords(vehicle)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = Vdist2(vehicleCoords, playerCoords)
        local vehicleClass = GetVehicleClass(vehicle)

        local radius = 8 -- default radius

        if vehicleClass == 0 then
            radius = 6 -- compacts
        elseif vehicleClass == 1 then
            radius = 8 -- sedans
        elseif vehicleClass == 2 then
            radius = 12 -- SUVs
        elseif vehicleClass == 3 then
            radius = 8 -- Coupes
        elseif vehicleClass == 4 then
            radius = 8 -- Muscle
        elseif vehicleClass == 5 or vehicleClass == 6 then
            radius = 8 -- Sports
        elseif vehicleClass == 7 then
            radius = 8 -- Super
        elseif vehicleClass == 8 then
            radius = 3 -- Motorcycles
        elseif vehicleClass == 9 then
            radius = 12
        -- Off-Road
        elseif vehicleClass == 10 or vehicleClass == 11 then
            radius = 14.5 -- Industrial and Utility
        elseif vehicleClass == 12 then
            radius = 11 -- Vans
        elseif vehicleClass == 13 then
            radius = 3 -- Cycles
        elseif vehicleClass == 14 then
            radius = 12 -- Boats
        elseif vehicleClass == 15 or vehicleClass == 16 then
            radius = 12 -- Helicopters and Planes
        elseif vehicleClass == 17 or vehicleClass == 18 or vehicleClass == 19 or vehicleClass == 20 then
            radius = 14.5 -- Service, Emergency, Military, and Commercial
        end

        if distance <= radius then
            if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
                    SetVehicleDoorOpen(vehicle, 4, false, false) -- 4 is the hood index
                    TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                    Citizen.Wait(20000)
                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleUndriveable(vehicle, false)
                    ClearPedTasksImmediately(playerPed)
                    TriggerServerEvent('repairCompleted', playerId)
                    ESX.ShowNotification("Your vehicle has been repaired!")
            else
                ESX.ShowNotification("You must target a vehicle that you are not inside of to repair it.")
            end
        else
            ESX.ShowNotification("The vehicle is too far away to repair.")
        end
    else
        ESX.ShowNotification("There is no vehicle nearby.")
    end
end)


RegisterNetEvent('checkrepairVehicle')
AddEventHandler('checkrepairVehicle', function()
    local playerId = GetPlayerServerId(PlayerId())
    TriggerServerEvent('validateRepairVehicle', playerId)
end) 