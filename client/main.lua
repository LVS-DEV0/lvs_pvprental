local delay = false
RegisterKeyMapping(LVS.Command, locale('kiralik_arac_menusu'), "keyboard", LVS.OpenKey)
RegisterCommand(LVS.Command, function()
    if not delay then
        if IsEntityDead(cache.ped) then
            Bridge.Notify(locale('notify_dead'), 'error')
            return
        end
        OpenRentalMenu()
    else
        Bridge.Notify(locale('notify_slow'), 'error')
    end
end)

function OpenRentalMenu()
    PlaySoundFrontend(-1, 'Click', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', false)
    local vehicles = {}
    for i, veh in ipairs(LVS.RentalVehicles) do
        table.insert(vehicles, {
            name = veh.name,
            model = veh.model,
            price = veh.price,
            vip = veh.vip,
            image = veh.image
        })
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openRental',
        vehicles = vehicles,
        locales = {
            title = locale('menu_title'),
            sub = locale('menu_sub'),
            free = locale('free'),
            rent_vehicle = locale('rent_vehicle'),
            close = locale('close')
        }
    })
end

RegisterNUICallback('closeRental', function(data, cb)
    PlaySoundFrontend(-1, 'Click', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', false)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('selectVehicle', function(data, cb)
    if delay then return end
    delay = true
    PlaySoundFrontend(-1, 'Click', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', false)
    local i = data.index
    if not IsPedInAnyVehicle(cache.ped, false) then
        local vehNetId, msg = lib.callback.await('lvs_rental:tryRentVehicle', false, i)
        local type = vehNetId and 'success' or 'error'
        Bridge.Notify(msg, type)
        if vehNetId then
            local timeout = 20
            while not NetworkDoesEntityExistWithNetworkId(vehNetId) and timeout > 0 do
                Wait(200)
                timeout = timeout - 1
            end
            if NetworkDoesEntityExistWithNetworkId(vehNetId) then
                local veh = NetToVeh(vehNetId)
                local timeout2 = 10
                while not DoesEntityExist(veh) and timeout2 > 0 do
                    Wait(200)
                    veh = NetToVeh(vehNetId)
                    timeout2 = timeout2 - 1
                end
                SetVehicleEngineOn(veh, true, true, true)
                SetPedIntoVehicle(cache.ped, veh, -1)
                SetVehicleOnGroundProperly(veh)
                Wait(5000) -- Kira sonrası bekleme süresi
                delay = false
            else
                Bridge.Notify(locale('notify_spawn_failed'), 'error')
                delay = false
            end
        else
            delay = false
        end
    else
        Bridge.Notify(locale('notify_in_veh'), 'error')
        delay = false
    end
    SetNuiFocus(false, false)
    cb('ok')
end)
