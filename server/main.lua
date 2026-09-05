lib.callback.register('lvs_rental:tryRentVehicle', function(source, i)
    local Player = Bridge.GetPlayer(source)
    if not Player then return false, locale('notify_invalid_player') end
    local data = LVS.RentalVehicles[i]
    if not data then return false, locale('notify_invalid_veh') end
    local ped = GetPlayerPed(source)
    local ptimeout = 20
    while not DoesEntityExist(ped) and ptimeout > 0 do
        Wait(150)
        ped = GetPlayerPed(source)
        ptimeout = ptimeout - 1
    end
    if not DoesEntityExist(ped) then return false, locale('notify_invalid_player') end
    local lastRentNetId = Entity(ped).state.rentedVehicle
    if lastRentNetId then
        local oldVeh = NetworkGetEntityFromNetworkId(lastRentNetId)
        if DoesEntityExist(oldVeh) then
            DeleteEntity(oldVeh)
        end
        Entity(ped).state:set("rentedVehicle", nil, false)
    end
    local finalPrice = data.price
    local vip = data.vip
    local model = data.model
    if vip then
        if Bridge.GetMoney(source, LVS.VipCoin) >= finalPrice then
            Bridge.RemoveMoney(source, LVS.VipCoin, finalPrice, "car-rental-vip")
        else
            return false, locale('notify_insufficient_vip', LVS.VipCoin)
        end
    else
        if Bridge.RemoveMoney(source, "cash", finalPrice, "car-rental") then
            -- Success
        elseif Bridge.RemoveMoney(source, "bank", finalPrice, "car-rental") then
            -- Success
        else
            return false, locale('notify_insufficient_money')
        end
    end
    local pedCoords = GetEntityCoords(ped)
    local pedHeading = GetEntityHeading(ped)
    local coords = vec4(pedCoords.x, pedCoords.y, pedCoords.z, pedHeading)

    local netId, vehicle = Bridge.SpawnVehicle(model, coords, ped)
    if vehicle and vehicle ~= 0 then
        Bridge.GiveKeys(source, vehicle)
        Entity(ped).state:set("rentedVehicle", netId, false)
        return netId, locale('notify_success')
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local ped = GetPlayerPed(src)
    if ped and ped ~= 0 then
        local netId = Entity(ped).state.rentedVehicle
        if netId then
            local vehicle = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        end
    end
end)
