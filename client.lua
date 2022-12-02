local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}
local tasking = false
local startVineyard = false
local random = 0
local pickedGrapes = 0
local blip = 0
local winetimer = Config.wineTimer
local loadIngredients = false
local wineStarted = false
local finishedWine = false
local grapeZones = {}
local Zones = {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

local function log(debugMessage)
    print(('^6[^3qb-vineyard^6]^0 %s'):format(debugMessage))
end

local function CreateBlip()
    if tasking then
        blip = AddBlipForCoord(Config.GrapeLocations[random].x, Config.GrapeLocations[random].y, Config.GrapeLocations[random].z)
    end

    SetBlipSprite(blip, 465)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Drop Off")
    EndTextCommandSetBlipName(blip)
end

local function nextTask()
    if tasking then
        return
    end

    random = math.random(#Config.GrapeLocations)
    tasking = true

    CreateBlip()
end

local function startVinyard()
    local amount = math.random(Config.PickAmount.min, Config.PickAmount.max)

    lib.notify({
        description = Lang:t("text.start_shift"),
        type = 'success'
    })

    while startVineyard do
        if tasking then
            Wait(5000)
        else
            nextTask()

            pickedGrapes = pickedGrapes + 1

            if pickedGrapes == amount then
                nextTask()

                Wait(20000)

                startVineyard = false
                pickedGrapes = 0

                lib.notify({
                    description = Lang:t("task.end_shift"),
                    type = 'error'
                })
            end
        end

        Wait(0)
    end
end

local function DeleteBlip()
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

local function pickProcess()
    if lib.progressBar({
        duration = math.random(6000, 8000),
        label = Lang:t("progress.pick_grapes"),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then
        tasking = false

        TriggerServerEvent("qb-vineyard:server:getGrapes")

        DeleteBlip()

        ClearPedTasks(cache.ped)
    else
        ClearPedTasks(cache.ped)

        lib.notify({
            description = Lang:t("task.cancel_task"),
            type = 'error'
        })
    end
end

local function PickAnim()
    lib.requestAnimDict('amb@prop_human_bum_bin@idle_a')

    TaskPlayAnim(cache.ped, 'amb@prop_human_bum_bin@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    RemoveAnimDict('amb@prop_human_bum_bin@idle_a')
end

for k = 1, #Config.GrapeLocations do
    local label = ("GrapeZone-%s"):format(k)

    grapeZones[k] = {
        isInside = false,
        zone = lib.zones.box({
            coords = Config.GrapeLocations[k],
            size = vec3(2, 2, 2),
            rotation = 0.0,
            debug = Config.Debug,
            onEnter = function(_)
                grapeZones[k].isInside = true

                if Config.Debug then
                    log(Lang:t("text.zone_entered", {
                        zone = label
                    }))

                    if k == random then
                        log(Lang:t("text.valid_zone"))
                    else
                        log(Lang:t("text.invalid_zone"))
                    end
                end

                if k == random then
                    CreateThread(function()
                        while grapeZones[k].isInside and k == random do
                            lib.showTextUI(Lang:t("task.start_task"))

                            if not IsPedInAnyVehicle(cache.ped) and IsControlJustReleased(0, 38) then
                                PickAnim()
                                pickProcess()

                                lib.hideTextUI()

                                random = 0
                            end

                            Wait(0)
                        end
                    end)
                end
            end,
            onExit = function(_)
                grapeZones[k].isInside = false

                if Config.Debug then
                    log(Lang:t("text.zone_exited",{zone=label}))
                end

                lib.hideTextUI()
            end
        })
    }
end

local function StartWineProcess()
    CreateThread(function()
        wineStarted = true

        while winetimer > 0 do
            winetimer = winetimer - 1

            Wait(1000)
        end

        wineStarted = false
        finishedWine = true
        winetimer = Config.wineTimer
    end)
end

local function PrepareAnim()
    lib.requestAnimDict('amb@code_human_wander_rain@male_a@base')

    TaskPlayAnim(cache.ped, 'amb@code_human_wander_rain@male_a@base', 'static', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
    RemoveAnimDict('amb@code_human_wander_rain@male_a@base')
end

local function grapeJuiceProcess()
    if lib.progressBar({
        duration = math.random(15000, 20000),
        label = Lang:t("progress.process_grapes"),
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then
        TriggerServerEvent("qb-vineyard:server:receiveGrapeJuice")

        ClearPedTasks(cache.ped)
    else
        ClearPedTasks(cache.ped)

        lib.notify({
            description = Lang:t("task.cancel_task"),
            type = 'error'
        })
    end
end

Zones[1] = {
    isInside = false,
    zone = lib.zones.poly({
        points = Config.Vineyard.start.zones,
        thickness = 2,
        debug = Config.Debug,
        onEnter = function(_)
            Zones[1].isInside = true

            if Config.Debug then
                log(Lang:t("text.zone_entered", {
                    zone = "Start"
                }))
            end

            if not startVineyard and PlayerJob.name == "vineyard" then
                lib.showTextUI(Lang:t("task.start_task"))

                CreateThread(function()
                    while Zones[1].isInside do
                        if IsControlJustReleased(0, 38) and not startVineyard then
                            startVineyard = true

                            startVinyard()
                        end

                        Wait(0)
                    end
                end)
            end
        end,
        onExit = function(_)
            Zones[1].isInside = false

            if Config.Debug then
                log(Lang:t("text.zone_exited", {
                    zone = "Start"
                }))
            end

            lib.hideTextUI()
        end
    })
}

Zones[2] = {
    isInside = false,
    zone = lib.zones.poly({
        points = Config.Vineyard.wine.zones,
        thickness = 2,
        debug = Config.Debug,
        onEnter = function(_)
            Zones[2].isInside = true

            if Config.Debug then
                log(Lang:t("text.zone_entered", {
                    zone = "Wine"
                }))
            end

            if not startVineyard and PlayerJob.name == "vineyard" then
                CreateThread(function()
                    while Zones[2].isInside do
                        if not wineStarted then
                            if not loadIngredients then
                                lib.showTextUI(Lang:t("task.load_ingrediants"))

                                if IsControlJustPressed(0, 38) then
                                    QBCore.Functions.TriggerCallback('qb-vineyard:server:loadIngredients', function(result)
                                        if result then
                                            loadIngredients = true
                                        end
                                    end)
                                end
                            else
                                if not finishedWine then
                                    lib.showTextUI(Lang:t("task.wine_process"))

                                    if IsControlJustPressed(0, 38) then
                                        StartWineProcess()
                                    end
                                else
                                    lib.showTextUI(Lang:t("task.get_wine"))

                                    if IsControlJustPressed(0, 38) then
                                        TriggerServerEvent("qb-vineyard:server:receiveWine")

                                        finishedWine = false
                                        loadIngredients = false
                                        wineStarted = false
                                    end
                                end
                            end
                        else
                            lib.showTextUI(Lang:t("task.countdown", {
                                time = winetimer
                            }))

                            Wait(999)
                        end

                        Wait(0)
                    end
                end)
            end
        end,
        onExit = function(_)
            Zones[2].isInside = false

            if Config.Debug then
                log(Lang:t("text.zone_exited", {
                    zone = "Wine"
                }))
            end

            lib.hideTextUI()
        end
    })
}

Zones[3] = {
    isInside = false,
    zone = lib.zones.poly({
        points = Config.Vineyard.grapejuice.zones,
        thickness = 2,
        debug = Config.Debug,
        onEnter = function(_)
            Zones[3].isInside = true

            if Config.Debug then
                log(Lang:t("text.zone_entered", {
                    zone = "Juice"
                }))
            end

            if not startVineyard and PlayerJob.name == "vineyard" then
                CreateThread(function()
                    while Zones[3].isInside do
                        lib.showTextUI(Lang:t("task.make_grape_juice"))

                        if IsControlJustPressed(0, 38) then
                            QBCore.Functions.TriggerCallback('qb-vineyard:server:grapeJuice', function(result)
                                if result then
                                    PrepareAnim()
                                    grapeJuiceProcess()
                                end
                            end)
                        end

                        Wait(0)
                    end
                end)
            end
        end,
        onExit = function(_)
            Zones[3].isInside = false

            if Config.Debug then
                log(Lang:t("text.zone_exited", {
                    zone = "Juice"
                }))
            end

            lib.hideTextUI()
        end
    })
}