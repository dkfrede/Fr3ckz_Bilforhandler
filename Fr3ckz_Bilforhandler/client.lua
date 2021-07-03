HT = nil
Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

local counter = 0
local vehicleOut = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if counter >= 1 then
			counter = counter - 1
		end
	end
end)

Citizen.CreateThread(function ()
    while true do
    local ped = PlayerPedId()
        Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), -32.11116027832,-1106.4288330078,26.422351837158, true) <= 2 then
                DrawText3Ds(-32.11116027832,-1106.4288330078,26.522351837158, "~w~[E] Bilforhandler Menu")
                    if IsControlJustReleased(0, 38) then
                        HT.TriggerServerCallback('checkDealerJob', function(Job)    
                        if Job == true then
                        openMenu()
                    end
                end)
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
    local ped = PlayerPedId()
        Citizen.Wait(1)
        if vehicleOut == true and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            DrawMarker(27, -35.978172302246,-1105.0877685547,26.422369003296-1, 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 255, 255, 255, 200, 0, 1, 0, 50)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), -35.978172302246,-1105.0877685547,26.422369003296, true) <= 5 then
                DrawText3Ds(-35.978172302246,-1105.0877685547,26.422369003296, "~w~[E] Indsæt Køretøj")
                    if IsControlJustReleased(0, 38) then
                    vehicleOut = false
                    ped = GetPlayerPed( -1 )
                    if ( ped ) then 
                    inVehicle = IsPedSittingInAnyVehicle( ped )
                    if ( inVehicle ) then 
                    car = GetVehiclePedIsIn( ped, false )
                    SetEntityAsMissionEntity( car, true, true )
                    deleteCar( car )
                    end
                    end
                end
            end
        end
    end
end)

function openMenu()
    local elements = {
        { label = "Sælg Køretøj", value = "sellVehicle" },
        { label = "Fremvis Køretøj", value = "showVehicle" },
        { label = "Send Besked", value = "sendMessage" },
    }
    HT.UI.Menu.Open('default', GetCurrentResourceName(), "vrp_htmenu",
        {
            title    = "Bilforhandler | Sælg Menu",
            align    = "right",
            elements = elements
        },
    function(data, menu)
        menu = menu
        if(data.current.value == 'sellVehicle') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Spiller ID"
            }, function(data2,menu)
                local playerid = data2.value
                menu.close()
            if playerid ~= nil then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Type? car/bike/citybike"
            }, function(data3,menu)
                local vehtype = data3.value
                menu.close()
            if vehtype ~= nil then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Køretøjs spawnkode"
            }, function(data1,menu)
                local spawncode = data1.value
                menu.close()
                if spawncode ~= nil then
                    menu.close()
                    HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                        title = "Køretøjs pris"
                    }, function(data,menu)
                        local price = data.value
                        menu.close()
                        if price ~= nil then
                            if tonumber(price) < tonumber(Config.MininimumMoneyAmount) then
                                menu.close()
                                exports['mythic_notify']:SendAlert('inform', 'Køretøjet skal minimun koste '..Config.MinimunMoneyAmount..'kr', 5000)
                            else
                                TriggerServerEvent("Fr3ckz_VehShop:GiveCar", spawncode, price, playerid, vehtype)
                            end
                        end
                    end)
                        end
                    end)
                end
            end)
            end
        end)
    end
        if(data.current.value == 'showVehicle') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Køretøjs spawnkode"
            }, function(data,menu)
                local thecar = data.value
                menu.close()
                if thecar ~= nil then
                    Citizen.Wait(1000)
                    HT.Game.SpawnVehicle(thecar, vector3(-39.1, -1101.5, 26.4), 5.0, function(vehicle)
                        local ped = PlayerPedId()
                        SetPedIntoVehicle(ped, vehicle, -1)
                        SetVehicleDirtLevel(vehicle, 0.1)
                        vehicleOut = true
                    end)
                end
            end)
        end
        if(data.current.value == 'sendMessage') then
            if counter == 0 then
            TriggerServerEvent("Fr3ckz_VehShop:sendMessage")
            counter = Config.CoolDownAmount
        else
            exports['mythic_notify']:SendAlert('inform', 'Du kan sende en ny meddelse om ' ..counter..' sekunder.')
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

function DrawText3Ds(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 20, 20, 20, 150)
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end