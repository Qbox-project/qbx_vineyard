local config = require 'config.client'
local sharedConfig = require 'config.shared'
local isLoggedIn = LocalPlayer.state.isLoggedIn

local function setLocationsBlip()
    for _, value in pairs(config.locations) do
        local blip = AddBlipForCoord(value.coords.x, value.coords.y, value.coords.z)
        SetBlipSprite(blip, value.blipIcon)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 83)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(value.blipName)
        EndTextCommandSetBlipName(blip)
    end
end

local function pickProcess()
    if lib.progressCircle({
            duration = math.random(6000, 8000),
            label = Lang:t('progress.pick_grapes'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true
            }
        }) then
        tasking = false
        TriggerServerEvent("qbx_vineyard:server:getGrapes")
    else
        exports.qbx_core:Notify(Lang:t('task.cancel_task'), 'error')
    end
    ClearPedTasks(cache.ped)
end

local function pickAnim()
    lib.requestAnimDict('amb@prop_human_bum_bin@idle_a')
    TaskPlayAnim(cache.ped, 'amb@prop_human_bum_bin@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local function toPickGrapes()
    if not IsPedInAnyVehicle(cache.ped, true) and IsControlJustReleased(0, 38) then
        pickAnim()
        pickProcess()
        random = 0
    end
end

local function wineProcessing()
    lib.callback('qbx_vineyard:server:grapeJuicesNeeded', false, function(result)
        if result then
            loadIngredients = true
            if lib.progressBar({
                    duration = 5000,
                    label = Lang:t('progress.process_wine'),
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        mouse = true,
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'mp_car_bomb',
                        clip = 'car_bomb_mechanic'
                    }
                }) then
                TriggerServerEvent('qbx_vineyard:server:receiveWine')
            else
                exports.qbx_core:Notify(Lang:t('task.cancel_task'), 'error')
            end
        else
            exports.qbx_core:Notify(Lang:t('error.invalid_items'), 'error')
        end
    end)
end

local function juiceProcessing()
    lib.callback('qbx_vineyard:server:grapesNeeded', false, function(result)
        if result then
            loadIngredients = true
            if lib.progressBar({
                    duration = 5000,
                    label = Lang:t('progress.process_juice'),
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        mouse = true,
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'mp_car_bomb',
                        clip = 'car_bomb_mechanic'
                    }
                }) then
                TriggerServerEvent('qbx_vineyard:server:receiveGrapeJuice')
            else
                exports.qbx_core:Notify(Lang:t('task.cancel_task'), 'error')
            end
        else
            exports.qbx_core:Notify(Lang:t('error.invalid_items'), 'error')
        end
    end)
end


local function processingMenu()
    lib.registerContext({
        id = 'processingMenu',
        title = Lang:t('menu.title'),
        options = {
            {
                title = Lang:t('menu.process_wine_title'),
                description = Lang:t('menu.wine_items_needed', { amount = sharedConfig.grapeJuicesNeeded }),
                icon = 'wine-bottle',
                onSelect = function()
                    wineProcessing()
                end,
            },
            {
                title = Lang:t('menu.process_juice_title'),
                description = Lang:t('menu.juice_items_needed', { amount = sharedConfig.grapesNeeded }),
                icon = 'bottle-droplet',
                onSelect = function()
                    juiceProcessing()
                end,
            }
        }
    })

    lib.showContext('processingMenu')
end

lib.zones.box({
    coords = config.locations.vineyardProcessing.coords,
    size = vec3(1.6, 1.4, 3.2),
    rotation = 346.25,
    debug = config.debugPoly,
    onExit = function()
        lib.hideTextUI()
    end,
    onEnter = function ()
        lib.showTextUI(Lang:t('task.vineyard_processing'))
    end,
    inside = function()
        if IsControlJustReleased(0, 38) then
            processingMenu()
        end
    end,
})

for _, coords in pairs(config.grapeLocations) do
    lib.zones.box({
        coords = coords,
        size = vec3(1, 1, 1),
        rotation = 40,
        debug = config.debugPoly,
        onExit = function()
            lib.hideTextUI()
        end,
        onEnter = function()
            lib.showTextUI(Lang:t("task.start_task"))
        end,
        inside = toPickGrapes,
    })
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if isLoggedIn and config.useBlips then setLocationsBlip() end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    RemoveBlip(blip)
end)