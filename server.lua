local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-vineyard:server:getGrapes', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.GrapeAmount.min, Config.GrapeAmount.max)
    Player.Functions.AddItem("grape", amount)
end)

lib.callback.register('qb-vineyard:server:loadIngredients', function(source)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local grape = exports.ox_inventory:GetItem(src, 'grapejuice', nil, true)
	if not Player.PlayerData.items then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = Lang:t("error.no_items")})
        return false
    end
    if grape < 23 then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = Lang:t("error.invalid_items")})
        return false
    end
    Player.Functions.RemoveItem("grapejuice", 23, false)
    return true
end)

lib.callback.register('qb-vineyard:server:grapeJuice', function(source)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local grape = exports.ox_inventory:GetItem(src, 'grape', nil, true)
	if not Player.PlayerData.items then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = Lang:t("error.no_items")})
        return false
    end
    if not grape or grape < 16 then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = Lang:t("error.invalid_items")})
        return false
    end
    Player.Functions.RemoveItem("grape", 16, false)
    return true
end)

RegisterNetEvent('qb-vineyard:server:receiveWine', function()
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.WineAmount.min, Config.WineAmount.max)
	Player.Functions.AddItem("wine", amount, false)
end)

RegisterNetEvent('qb-vineyard:server:receiveGrapeJuice', function()
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max)
	Player.Functions.AddItem("grapejuice", amount, false)
end)
