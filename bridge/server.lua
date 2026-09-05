Bridge = {}

local Framework = nil
local QBCore = nil
local ESX = nil

if GetResourceState('qbx_core') == 'started' then
    Framework = 'qbx'
elseif GetResourceState('qb-core') == 'started' then
    Framework = 'qb'
    QBCore = exports['qb-core']:GetCoreObject()
elseif GetResourceState('es_extended') == 'started' then
    Framework = 'esx'
    ESX = exports['es_extended']:getSharedObject()
end

function Bridge.GetPlayer(source)
    if Framework == 'qbx' then
        return exports.qbx_core:GetPlayer(source)
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayer(source)
    elseif Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    end
    return nil
end

function Bridge.GetMoney(source, type)
    local Player = Bridge.GetPlayer(source)
    if not Player then return 0 end

    if Framework == 'qbx' then
        return Player.Functions.GetMoney(type)
    elseif Framework == 'qb' then
        return Player.Functions.GetMoney(type)
    elseif Framework == 'esx' then
        local account = Player.getAccount(type)
        return account and account.money or 0
    end
    return 0
end

function Bridge.RemoveMoney(source, type, amount, reason)
    local Player = Bridge.GetPlayer(source)
    if not Player then return false end

    if Framework == 'qbx' then
        return Player.Functions.RemoveMoney(type, amount, reason)
    elseif Framework == 'qb' then
        return Player.Functions.RemoveMoney(type, amount, reason)
    elseif Framework == 'esx' then
        if Bridge.GetMoney(source, type) >= amount then
            Player.removeAccountMoney(type, amount)
            return true
        end
    end
    return false
end

function Bridge.GiveKeys(source, vehicle)
    if GetResourceState('qbx_vehiclekeys') == 'started' then
        exports.qbx_vehiclekeys:GiveKeys(source, vehicle)
    elseif GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerClientEvent('vehiclekeys:client:GiveKeys', source, GetVehicleNumberPlateText(vehicle))
    elseif GetResourceState('wasabi_carkeys') == 'started' then
        exports.wasabi_carkeys:GiveKeys(GetVehicleNumberPlateText(vehicle))
    end
end

function Bridge.SpawnVehicle(model, coords, warp)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
    local timeout = 20
    while not DoesEntityExist(vehicle) and timeout > 0 do
        Wait(300)
        timeout = timeout - 1
    end
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local timeout2 = 10
    while (not netId or netId == 0) and timeout2 > 0 do
        Wait(150)
        netId = NetworkGetNetworkIdFromEntity(vehicle)
        timeout2 = timeout2 - 1
    end
    if warp then
        TaskWarpPedIntoVehicle(warp, vehicle, -1)
    end
    return netId, vehicle
end
