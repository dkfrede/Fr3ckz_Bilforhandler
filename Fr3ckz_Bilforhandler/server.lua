MySQL = module("vrp_mysql", "MySQL")
HT = nil
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)

HT.RegisterServerCallback('checkDealerJob', function(source, cb)
    local user_id = vRP.getUserId({source})

    if vRP.hasGroup({user_id, Config.Rank}) then
        cb(true)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ingen adgang!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
        cb(false)
    end
end)

RegisterNetEvent("Fr3ckz_VehShop:sendMessage")
AddEventHandler("Fr3ckz_VehShop:sendMessage", function()
    local source = source
    local user_id = vRP.getUserId({source})

    vRP.getUserIdentity({user_id, function(identity)
        nuserIdentity = ''..identity.firstname..' '..identity.name..'' 
        TriggerClientEvent("chat:addMessage", -1, {
        args = {
            "^1" ..nuserIdentity.. " ^0| Bilforhandleren holder nu åbent - kig forbi!",
        },
        })    
    end})
end)

RegisterNetEvent("Fr3ckz_VehShop:GiveCar")
AddEventHandler("Fr3ckz_VehShop:GiveCar", function(vehiclecode, vehprice, vehicleid, veh_type)
    local source = source
    local user_id = vRP.getUserId({source})
    local vehicleplID = vRP.getUserId({vehicleid})
    local vehiclesource = vRP.getUserSource({vehicleplID})
    if user_id ~= nil then
        vRP.request({vehiclesource,"Vil du købe en "..vehiclecode.." for "..vehprice.."kr?",200,function(vehiclesource,ok)
            if ok then
                if vRP.tryFullPayment({tonumber(vehicleid),tonumber(vehprice)}) then
                    vRP.getUserIdentity({tonumber(vehicleid), function(identity)
                    MySQL.query("vRP/add_custom_vehicle", {user_id = tonumber(vehicleid), vehicle = vehiclecode, vehicle_plate = "P "..identity.registration, veh_type = veh_type})
                    TriggerClientEvent('mythic_notify:client:SendAlert', vehiclesource, { type = 'inform', text = 'Du modtog en '..vehiclecode..' for '..vehprice..'kr. Du kan finde køretøjet i din garage.', length = 30000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })


                    -- logs
                    PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
                        {
                            username = "Fr3ckz_Bilforhandler | Salg af Køretøj",
                            embeds = {
                                {              
                                    title = "🚗 | Fr3ckz_Bilforhandler | Salg af Køretøj";
                                    description = 'Bilforhandler ID: **'..user_id..'**\nKøretøj: **'..vehiclecode..'**\nPris: **'..vehprice..'**\nSpiller solgt til: **'..vehicleplID..'**\n Made by **Fr3ckz#5839**';
                                    color = 15731467;
                                }
                            }
                        }), { ['Content-Type'] = 'application/json' })

                    -- send money and message to dealer
                    local dealermoney = math.floor(tonumber(vehprice)/100*Config.ProcentToDealer)
                    vRP.giveBankMoney({user_id,dealermoney})
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Din kunde '..identity.firstname..' '..identity.name..' tog imod dit offer på en '..vehiclecode..', du tjente '..dealermoney..'kr', length = 30000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
                    end})
                end
            end
        end})
    end
end)
