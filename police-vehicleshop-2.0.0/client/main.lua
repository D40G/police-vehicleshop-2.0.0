local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

-- dont edit
RegisterNetEvent('police:client:SaveCar', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)

    if veh ~= nil and veh ~= 0 then
        local plate = QBCore.Functions.GetPlate(veh)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local hash = props.model
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        if QBCore.Shared.Vehicles[vehname] ~= nil and next(QBCore.Shared.Vehicles[vehname]) ~= nil then
            TriggerServerEvent('police:server:SaveCarData', props, QBCore.Shared.Vehicles[vehname], `veh`, plate)
        else
            QBCore.Functions.Notify('You cant store this vehicle in your garage..', 'error')
        end
    else
        QBCore.Functions.Notify('You are not in a vehicle..', 'error')
    end
end)


RegisterNetEvent('police:client:garage')
AddEventHandler('police:client:garage', function(pd)
    local vehicle = pd.vehicle
    local coords = { ['x'] = 455.19, ['y'] = -1019.8, ['z'] = 28.33, ['h'] = 90.44 }
    local key = pd.key

    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        -- SetVehicleNumberPlateText(veh, 'pol'..tostring(math.random(1000, 9999)))
        SetVehicleNumberPlateText(vehicle, plate)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        SetEntityHeading(veh, coords.h)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        print(vehicle)
    end, coords, true)
    Wait(200)
    TriggerEvent('police:client:SaveCar')
    TriggerServerEvent('police:server:takekey', key)
end)


RegisterNetEvent('police:client:npolvic')
AddEventHandler('police:client:npolvic', function()
            local myMenu = {
                {
                    id = 1,
                    header = 'police ford vic'
                },
                {
                    id = 2,
                    header = "< take",
                    txt = "police ford vic",
                    params = {
                        event = "police:client:garage", --- event name
                        args = {
                            vehicle = Config.vehicle.npolvic,
                            key = Config.vehicle.npolvic
                        }
                    }
                },
                {
                    id = 3,
                    header = '< close',
                    txt = '',
                    params = {
                        event = '',
                    }
                },
            }
            exports['qb-menu']:openMenu(myMenu)
end)


RegisterNetEvent('police:client:npolchar')
AddEventHandler('police:client:npolchar', function()
            local myMenu = {
                {
                    id = 1,
                    header = 'police dodge charger'
                },
                {
                    id = 2,
                    header = "< take",
                    txt = "police dodge charger",
                    params = {
                        event = "police:client:garage", --- event name
                        args = {
                            vehicle = Config.vehicle.npolchar,
                            key = Config.vehicle.npolchar
                        }
                    }
                },
                {
                    id = 3,
                    header = '< close',
                    txt = '',
                    params = {
                        event = '',
                    }
                },
            }
            exports['qb-menu']:openMenu(myMenu)
end)


RegisterNetEvent('police:client:GiveCarKey', function(pd)
   local money = pd.money
   local key = pd.key 

   TriggerServerEvent('police:server:buykey', money, key)
end)
    

RegisterNetEvent('police:client:KeysMenu')
AddEventHandler('police:client:KeysMenu', function()
            local myMenu = {
                {
                    id = 1,
                    header = 'police vehicle shop'
                },
                {
                    id = 2,
                    header = "< buy",
                    txt = "police ford vic (key)",
                    params = {
                        event = "police:client:GiveCarKey", --- money remove and add item
                        args = {
                            money = Config.cost.npolvic, -- cost of the car
                            key = Config.vehicle.npolvic -- name of the item
                        }
                    }
                },
                {
                    id = 3,
                    header = "< buy",
                    txt = "police dodge charger (key)",
                    params = {
                        event = "police:client:GiveCarKey", --- event name
                        args = {
                            money = Config.cost.npolchar,
                            key = Config.vehicle.npolchar
                        }
                    }
                },
                {
                    id = 4,
                    header = '< close',
                    txt = '',
                    params = {
                        event = '',
                    }
                },
            }
            exports['qb-menu']:openMenu(myMenu)
end)


RegisterCommand('livery', function(source, args)
	if (PlayerJob.name == "police") then
        local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
        local liveryID = tonumber(args[1])
        
        SetVehicleLivery(Veh, liveryID)
        else
            QBCore.Functions.Notify('you don`t have the job', "error", 5000)
    end
    end, false)
