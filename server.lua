local QBCore = exports['qb-core']:GetCoreObject()

---@param item string The item that is required by the recipe
---@param requirement integer The amount required by the recipe
---@return boolean callback The value sent back to the client
local function loadIngredients(item, requirement)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local itemCount = exports.ox_inventory:GetItem(src, item, nil, true)
	if not Player.PlayerData.items then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = Lang:t("error.no_items")})
        return false
    end
    if itemCount < requirement then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = Lang:t("error.invalid_items")})
        return false
    end
    Player.Functions.RemoveItem(item, requirement, false)
    return true
end

lib.callback.register('qb-vineyard:server:loadIngredients', function()
    return loadIngredients('grapejuice', 23)
end)

lib.callback.register('qb-vineyard:server:grapeJuice', function()
    return loadIngredients('grape', 16)
end)

RegisterNetEvent('qb-vineyard:server:getGrapes', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local amount = math.random(Config.GrapeAmount.min, Config.GrapeAmount.max)
    Player.Functions.AddItem("grape", amount)
end)

<<<<<<< HEAD
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
=======
RegisterNetEvent('qb-vineyard:server:receiveWine', function()
	local Player = QBCore.Functions.GetPlayer(source)
>>>>>>> b783c68 (Refactor(server): Extracted Function)
    local amount = math.random(Config.WineAmount.min, Config.WineAmount.max)
    Player.Functions.AddItem("wine", amount, false)
end)

RegisterNetEvent('qb-vineyard:server:receiveGrapeJuice', function()
<<<<<<< HEAD
    local Player = QBCore.Functions.GetPlayer(tonumber(source))
=======
	local Player = QBCore.Functions.GetPlayer(source)
>>>>>>> b783c68 (Refactor(server): Extracted Function)
    local amount = math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max)
    Player.Functions.AddItem("grapejuice", amount, false)
end)
