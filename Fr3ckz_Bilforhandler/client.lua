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
            if GetDistanceBetweenCoords(GetEntityCoords(ped), -30.745897293091,-1111.0944824219,26.422344207764, true) <= 2 then
                DrawText3Ds(-30.745897293091,-1111.0944824219,26.422344207764, "~w~[E] Bilforhandler Admin Menu")
                    if IsControlJustReleased(0, 38) then
                        HT.TriggerServerCallback('checkAdminDealerJob', function(Job)    
                        if Job == true then
                        openAdminMenu()
                    end
                end)
            end
        end
        if vehicleOut == true and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            DrawMarker(27, -35.978172302246,-1105.0877685547,26.422369003296-1, 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 255, 255, 255, 200, 0, 1, 0, 50)
            if GetDistanceBetweenCoords(GetEntityCoords(ped), -35.978172302246,-1105.0877685547,26.422369003296, true) <= 5 then
                DrawText3Ds(-35.978172302246,-1105.0877685547,26.422369003296, "~w~[E] Indsæt Køretøj")
                    if IsControlJustReleased(0, 38) then
                    vehicleOut = false
                    local ped = GetPlayerPed( -1 )
                    local inVehicle = IsPedSittingInAnyVehicle( ped )
                    local car = GetVehiclePedIsIn( ped, false )
                    SetEntityAsMissionEntity( car, true, true )
                    deleteCar( car )
                end
            end
        end
        end
    --end
end)

function openAdminMenu()
    local elements = {
        { label = "Ansæt Bilforhandler", value = "ansatDealer" },
        { label = "Fyr Bilforhandler", value = "removeDealer" },
        { label = "Online Bilforhandlere", value = "onlineDealer" },
        { label = "Send Meddelse", value = "sendMessageToDealers" },
    }
    HT.UI.Menu.Open('default', GetCurrentResourceName(), "vrp_htmenu",
        {
            title    = "Bilforhandler | Admin Menu",
            align    = "right",
            elements = elements
        },
    function(data, menu)
        menu = menu
        if(data.current.value == 'ansatDealer') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Spiller ID"
            }, function(data2,menu)
                local playerid = data2.value
                menu.close()
            if playerid ~= nil then
            menu.close()
            TriggerServerEvent("Fr3ckz_VehShop:ansatDealer", playerid)
            end
        end)
        end
        if(data.current.value == 'removeDealer') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Spiller ID"
            }, function(data3,menu)
                local playerid = data3.value
                menu.close()
            if playerid ~= nil then
            menu.close()
            TriggerServerEvent("Fr3ckz_VehShop:removeDealer", playerid)
            end
        end)
        end
        if(data.current.value == 'sendMessageToDealers') then
            menu.close()
            HT.UI.Menu.Open('dialog', GetCurrentResourceName(), '', {
                title = "Besked"
            }, function(data4,menu)
                local message = data4.value
                menu.close()
            if message ~= nil then
            menu.close()
            TriggerServerEvent("Fr3ckz_VehShop:messageDealers", message)
            end
        end)
        end
        if(data.current.value == 'onlineDealer') then
            menu.close()
            openOnlineMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

if Config.CustomerMessage.Enabled == "true" or Config.CustomerMessage == true then
    RegisterCommand(Config.CustomerMessage.Command, function(source, args, rawCommand)
        local location = args[1]
        if args[1] == nil or args[1] == "" then
            exports['mythic_notify']:SendAlert('inform', 'Du mangler og skrive en lokation på bilforhandleren.')
        else
            sm = stringsplit(rawCommand, " ");
            local message = ""
            for i = 3, #sm do
            message = message .. sm[i] .. " "
            
            if message == "" or message == nil then
                exports['mythic_notify']:SendAlert('inform', 'Du mangler og indtaste en meddelse')
            else
            -- triggers server event, with send message to dealers
            TriggerServerEvent("Fr3ckz_VehShop:sendMessageCustomerToDealer", location, message)
            end
            end
        end
    end)
end

--print(Config.CustomerMessage.Enabled)

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
                                exports['mythic_notify']:SendAlert('inform', 'Køretøjet skal minimun koste '..Config.MininimumMoneyAmount..'kr', 5000)
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
                        exports['mythic_notify']:SendAlert("inform", "Du tog en "..thecar.." ud, med nummerpladen "..GetVehicleNumberPlateText(vehicle).."") 
                        TriggerServerEvent("Fr3ckz_VehShop:sendLogToit", thecar)
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

function openOnlineMenu()
    HT.TriggerServerCallback('checkOnliners', function(result) 
        local elements = {}
        for k,v in pairs(result) do
            table.insert(elements, {label  = v.firstname..' '..v.name})
        end
        HT.UI.Menu.Open('default', GetCurrentResourceName(), '', {
            title    = "Bilforhandler | Online",
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()
        end, function(data, menu)
            menu.close()
            Citizen.Wait(400)
        end)
    end)
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
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