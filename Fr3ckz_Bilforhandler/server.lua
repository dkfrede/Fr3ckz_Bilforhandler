MySQL = module("vrp_mysql", "MySQL")
HT = nil
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)

-- // COMMAND \\ --
MySQL.createCommand("vRP/get_identity","SELECT * FROM vrp_user_identities WHERE user_id = @user_id")   

if Config.Webhook == "" or Config.Webhook == nil then
    print("[Fr3ckz_Bilforhandler] Du mangler og indtaste et webhook!")
    print("[Fr3ckz_Bilforhandler] Du mangler og indtaste et webhook!")
    print("[Fr3ckz_Bilforhandler] Du mangler og indtaste et webhook!")
end

HT.RegisterServerCallback('checkDealerJob', function(source, cb)
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, Config.Rank}) then
        cb(true)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ingen adgang!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
        cb(false)
    end
end)

HT.RegisterServerCallback('checkAdminDealerJob', function(source, cb)
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, Config.AdminRank}) then
        cb(true)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Ingen adgang!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
        cb(false)
    end
end)

HT.RegisterServerCallback('checkOnliners', function(source, cb)
    local allUsers = vRP.getUsers({})
    for k,v in pairs(allUsers) do
        local users_id = vRP.getUserId({v})
        if vRP.hasGroup({users_id, Config.Rank}) then
            MySQL.query("vRP/get_identity", {user_id = users_id}, function(identity)
                cb(identity)
            end)
        else
            cb(false) -- why im stupid :/
        end
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
        PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
            {
                username = "Fr3ckz_Bilforhandler | Besked Til Alle (reklame)",
                embeds = {
                    {              
                        title = "🚗 | Fr3ckz_Bilforhandler | Besked Til Alle (reklame)";
                        description = 'Bilforhandler ID: **'..user_id..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\n Made by **Fr3ckz#5839**';
                        color = 15731467;
                    }
                }
            }), { ['Content-Type'] = 'application/json' })    
    end})
end)

RegisterNetEvent("Fr3ckz_VehShop:sendLogToit")
AddEventHandler("Fr3ckz_VehShop:sendLogToit", function(vehicle)
    local source = source
    local user_id = vRP.getUserId({source})
    PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
        {
            username = "Fr3ckz_Bilforhandler | Fremvis Køretøj",
            embeds = {
                {              
                    title = "🚗 | Fr3ckz_Bilforhandler | Fremvis Køretøj";
                    description = 'Bilforhandler ID: **'..user_id..'**\nKøretøj: **'..vehicle..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\n Made by **Fr3ckz#5839**';
                    color = 15731467;
                }
             }
        }), { ['Content-Type'] = 'application/json' })    
end)

RegisterNetEvent("Fr3ckz_VehShop:sendMessageCustomerToDealer")
AddEventHandler("Fr3ckz_VehShop:sendMessageCustomerToDealer", function(lokation, besked)
    local source = source
    local user_id = vRP.getUserId({source})
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du sendte en besked til bilforhandlerne', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
    local players = vRP.getUsers({})
    for k,v in pairs(players) do
        local dealersID = vRP.getUserId({players})
            if vRP.hasGroup({user_id, Config.Rank}) then
                vRP.getUserIdentity({user_id, function(identity)
                TriggerClientEvent('mythic_notify:client:SendAlert', v, { type = 'inform', text = 'I modtog en besked, fra: '..identity.firstname..' ' ..identity.name..' lokation: '..lokation..' besked: '..besked..'', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
                end})
            end
        end
    PerformHttpRequest(Config.CustomerMessage.Log, function(o,p,q) end,'POST',json.encode(
        {
            username = "Fr3ckz_Bilforhandler | Kunde Besked",
            embeds = {
                {              
                    title = "🚗 | Fr3ckz_Bilforhandler | Kunde Besked";
                    description = 'Spiller ID: **'..user_id..'**\nLokation: **'..lokation..'**\nMeddelse: **'..besked..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\n Made by **Fr3ckz#5839**';
                    color = 15731467;
                }
             }
        }), { ['Content-Type'] = 'application/json' })    
end)

RegisterNetEvent("Fr3ckz_VehShop:ansatDealer")
AddEventHandler("Fr3ckz_VehShop:ansatDealer", function(playerID)
    local source = source
    local user_id = vRP.getUserId({source})
    local targetID = tonumber(playerID)
    local targetSource = vRP.getUserSource({targetID})
    vRP.getUserIdentity({targetID, function(identity)
    vRP.addUserGroup({targetID,"Bilforhandler"})
    TriggerClientEvent('mythic_notify:client:SendAlert', targetSource, { type = 'inform', text = 'Du er blevet ansat som bilforhandler!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du ansatte '..identity.firstname.. ' '..identity.name..' som bilforhandler!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
    PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
        {
            username = "Fr3ckz_Bilforhandler | Tilføj Bilforhandler",
            embeds = {
                {              
                    title = "🚗 | Fr3ckz_Bilforhandler | Tilføj Bilforhandler";
                    description = 'Bilforhandler ID: **'..user_id..'**\nTarget ID: **'..targetID..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\n Made by **Fr3ckz#5839**';
                    color = 15731467;
                }
            }
        }), { ['Content-Type'] = 'application/json' })    
    if Config.GlobalMessage then
        --print("hejsa")
        local allPlayers = vRP.getUsers({v})
        for k,v in pairs(allPlayers) do
            local user_id2 = vRP.getUserId({v})
            if vRP.hasGroup({user_id2, Config.Rank}) then
            TriggerClientEvent('mythic_notify:client:SendAlert', v, { type = 'inform', text = ''..identity.firstname.. ' '..identity.name..' er lige blevet ansat som bilforhandler!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
            end
        end
    end
    end})
end)

RegisterNetEvent("Fr3ckz_VehShop:removeDealer")
AddEventHandler("Fr3ckz_VehShop:removeDealer", function(playerID)
    local source = source
    local user_id = vRP.getUserId({source})
    local targetID = tonumber(playerID)
    local targetSource = vRP.getUserSource({targetID})
    vRP.getUserIdentity({targetID, function(identity)
    vRP.removeUserGroup({targetID,"Bilforhandler"})
    TriggerClientEvent('mythic_notify:client:SendAlert', targetSource, { type = 'inform', text = 'Du er blevet fyret som bilforhandler!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du fyrede '..identity.firstname.. ' '..identity.name..' som bilforhandler!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
    PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
        {
            username = "Fr3ckz_Bilforhandler | Fjern Bilforhandler",
            embeds = {
                {              
                    title = "🚗 | Fr3ckz_Bilforhandler | Fjern Bilforhandler";
                    description = 'Bilforhandler ID: **'..user_id..'**\nTarget ID: **'..targetID..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\n Made by **Fr3ckz#5839**';
                    color = 15731467;
                }
            }
        }), { ['Content-Type'] = 'application/json' })    
    if Config.GlobalMessage then
        --print("hejsa")
        local allPlayers = vRP.getUsers({v})
        for k,v in pairs(allPlayers) do
            local user_id2 = vRP.getUserId({v})
            if vRP.hasGroup({user_id2, Config.Rank}) then
            TriggerClientEvent('mythic_notify:client:SendAlert', v, { type = 'inform', text = ''..identity.firstname.. ' '..identity.name..' er lige blevet fyret som bilforhandler!', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
            end
        end
    end
    end})
end)

RegisterNetEvent("Fr3ckz_VehShop:messageDealers")
AddEventHandler("Fr3ckz_VehShop:messageDealers", function(message)
    local source = source
    local user_id = vRP.getUserId({source})
    local meddelse = message
    local allPlayers = vRP.getUsers({v})
    vRP.getUserIdentity({user_id, function(identity)
    for k,v in pairs(allPlayers) do
        local user_id2 = vRP.getUserId({v})
        if vRP.hasGroup({user_id2, Config.Rank}) then
            PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
                {
                    username = "Fr3ckz_Bilforhandler | Send Besked Til Bilforhandlere",
                    embeds = {
                        {              
                            title = "🚗 | Fr3ckz_Bilforhandler | Send Besked Til Bilforhandlere";
                            description = 'Bilforhandler ID: **'..user_id..'**\nBesked: **'..message..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\n Made by **Fr3ckz#5839**';
                            color = 15731467;
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })    
        TriggerClientEvent('mythic_notify:client:SendAlert', v, { type = 'inform', text = 'Bilforhandler Besked Fra: '..identity.firstname.. ' '..identity.name.. ' - '..message..'', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
        end
    end
end})
end)

-- fixed 30-07-2021
RegisterNetEvent("Fr3ckz_VehShop:GiveCar")
AddEventHandler("Fr3ckz_VehShop:GiveCar", function(vehiclecode, vehprice, vehicleid, veh_type)
    local source = source
    local user_id = vRP.getUserId({source})
    local vehiclesource = vRP.getUserSource({tonumber(vehicleid)})
    local vehicleplID = vRP.getUserId({vehiclesource})
    if user_id ~= nil then
        vRP.request({vehiclesource,"Vil du købe en "..vehiclecode.." for "..vehprice.."kr?",200,function(vehiclesource,ok)
            if ok then
                if vRP.tryFullPayment({vehicleplID,tonumber(vehprice)}) then
                    vRP.getUserIdentity({vehicleplID, function(identity)
                    MySQL.query("vRP/add_custom_vehicle", {user_id = vehicleplID, vehicle = vehiclecode, vehicle_plate = "P "..identity.registration, veh_type = veh_type})
                    TriggerClientEvent('mythic_notify:client:SendAlert', vehiclesource, { type = 'inform', text = 'Du modtog en '..vehiclecode..' for '..vehprice..'kr. Du kan finde køretøjet i din garage.', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
                    -- logs
                    PerformHttpRequest(Config.Webhook, function(o,p,q) end,'POST',json.encode(
                        {
                            username = "Fr3ckz_Bilforhandler | Salg af Køretøj",
                            embeds = {
                                {              
                                    title = "🚗 | Fr3ckz_Bilforhandler | Salg af Køretøj";
                                    description = 'Bilforhandler ID: **'..user_id..'**\nKøretøj: **'..vehiclecode..'**\nPris: **'..vehprice..'**\nSpiller solgt til: **'..vehicleplID..'**\nTid: **'..os.date("%H:%M:%S %d/%m/%Y")..'**\nMade by **Fr3ckz#5839**';
                                    color = 15731467;
                                }
                            }
                        }), { ['Content-Type'] = 'application/json' })

                    -- send money and message to dealer
                    local dealermoney = math.floor(tonumber(vehprice)/100*Config.ProcentToDealer)
                    vRP.giveBankMoney({user_id,dealermoney})
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Din kunde '..identity.firstname..' '..identity.name..' tog imod dit offer på en '..vehiclecode..', du tjente '..dealermoney..'kr.', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
                --end
                    end})
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Din kunde har ikke råd til dit offer på en '..vehiclecode..'', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
                    TriggerClientEvent('mythic_notify:client:SendAlert', vehiclesource, { type = 'inform', text = 'Du har ikke råd til en '..vehiclecode..'', length = 10000, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
                end
            end
        end})
    end
end)
