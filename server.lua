local QBCore = exports['qbx-core']:GetCoreObject()
local picked = {}

---@param item string The item that is required by the recipe
---@param requirement integer The amount required by the recipe
---@return boolean callback The value sent back to the client
local function loadIngredients(item, requirement)
    local src = source
	local player = QBCore.Functions.GetPlayer(src)
    local itemCount = exports.ox_inventory:GetItem(src, item, nil, true)
	if not player.PlayerData.items then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_items'), 'error')
        return false
    end
    if itemCount < requirement then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.invalid_items'), 'error')
        return false
    end
    player.Functions.RemoveItem(item, requirement, false)
    return true
end

---@param limit integer Cooldown for netevents
---@return boolean onCooldown If the player is on cooldown from triggering the event
local function onCooldown(limit)
    local time = os.time()
    if picked[source] and time - picked[source] < limit then return true end
    picked[source] = time
    return false
end

---@param item string Item to be added to player inventory
---@param amount integer Amount of item to be added to inventory
local function addItem(item, amount)
    if onCooldown(20) then return end
    local player = QBCore.Functions.GetPlayer(source)
    player.Functions.AddItem(item, amount)
end

lib.callback.register('qb-vineyard:server:loadIngredients', function()
    return loadIngredients('grapejuice', 23)
end)

lib.callback.register('qb-vineyard:server:grapeJuice', function()
    return loadIngredients('grape', 16)
end)

RegisterNetEvent('qb-vineyard:server:getGrapes', function()
    addItem("grape", math.random(Config.GrapeAmount.min, Config.GrapeAmount.max))
end)

RegisterNetEvent('qb-vineyard:server:receiveWine', function()
    addItem("wine", math.random(Config.WineAmount.min, Config.WineAmount.max))
end)

RegisterNetEvent('qb-vineyard:server:receiveGrapeJuice', function()
	addItem("grapejuice", math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max))
end)
