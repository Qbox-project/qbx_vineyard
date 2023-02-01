local QBCore = exports['qb-core']:GetCoreObject()

local grapeZones = {}
local blip = 0
local winetimer = Config.wineTimer
local grapeLocations = Config.grapeLocations
local loadIngredients = false
local wineStarted = false
local finishedWine = false

local function DeleteBlip()
	if not DoesBlipExist(blip) then return end
	RemoveBlip(blip)
end

local function pickProcess()
	if lib.progressCircle({label = Lang:t("progress.pick_grapes"), duration = math.random(6000,8000), canCancel = true, disable = {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	},}
	) then
		tasking = false
        TriggerServerEvent("qb-vineyard:server:getGrapes")
		DeleteBlip()
	else
		lib.notify({description= {Lang:t("task.cancel_task")}, type = "error"})
	end
	ClearPedTasks(cache.ped)
end

local function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function PickAnim()
    local ped = cache.ped
    LoadAnim('amb@prop_human_bum_bin@idle_a')
    TaskPlayAnim(ped, 'amb@prop_human_bum_bin@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local function exitZone()
	if not Config.Debug then return end
	lib.notify({description = "Zone Exited", type = "inform"})
	lib.hideTextUI()
end

local function enterZone()
	if not Config.Debug then return end
	lib.notify({description = "Zone Entered", type = "inform"})
end

local function toPickGrapes()
	lib.showTextUI(Lang:t("task.start_task"), {position = 'right'})
	if not IsPedInAnyVehicle(cache.ped) and IsControlJustReleased(0,38) then
		PickAnim()
		pickProcess()
		lib.hideTextUI()
		random = 0
	end
end

local function StartWineProcess()
    CreateThread(function()
        wineStarted = true
        while winetimer > 0 do
            winetimer = winetimer - 1
            Wait(1000)
		end
		wineStarted = false
		loadIngredients = false
		finishedWine = true
		winetimer = Config.wineTimer
    end)
end


local function PrepareAnim()
    local ped = cache.ped
    LoadAnim('amb@code_human_wander_rain@male_a@base')
    TaskPlayAnim(ped, 'amb@code_human_wander_rain@male_a@base', 'static', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local function grapeJuiceProcess()
	if lib.progressCircle({label = Lang:t("progress.process_grapes"), duration = math.random(15000,20000), canCancel = true, disable = {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	},}) then
		TriggerServerEvent("qb-vineyard:server:receiveGrapeJuice")
	else
		lib.notify({description= {Lang:t("task.cancel_task")}, type = "error"})
	end
	ClearPedTasks(cache.ped)
end

local function workWine()
	if wineStarted then
		lib.showTextUI(Lang:t("task.countdown"), {position = 'right'})
		return
	end

	if loadIngredients then
		lib.showTextUI(Lang:t("task.process_wine"), {position = 'right'})
		if IsControlJustReleased(0, 38) and not LocalPlayer.state.invBusy then
			StartWineProcess()
		end
		return
	end

	if finishedWine then
		lib.showTextUI(Lang:t("task.get_wine"), {position = 'right'})
		if IsControlJustReleased(0, 38) and not LocalPlayer.state.invBusy then
			TriggerServerEvent("qb-vineyard:server:receiveWine")
			finishedWine = false
			loadIngredients = false
			wineStarted = false
		end
		return
	end

	lib.showTextUI(Lang:t("task.load_ingrediants"), {position = 'right'})
	if LocalPlayer.state.invBusy then return end
	if IsControlJustReleased(0, 38) and not LocalPlayer.state.invBusy then
		lib.callback('qb-vineyard:server:loadIngredients', false, function(result)
			if result then loadIngredients = true end
		end)
	end
end

local function juiceWork()
	if IsControlJustReleased(0, 38) and not LocalPlayer.state.invBusy then
		lib.callback('qb-vineyard:server:grapeJuice', false, function(result)
			if result then PrepareAnim() grapeJuiceProcess() end
		end)
		return false
	end
	return true
end

WineZones = lib.zones.poly({
	points = Config.Vineyard.wine.zones,
	thickness = 2,
	debug = Config.Debug,
	onExit = exitZone,
	onEnter = enterZone,
	inside = workWine
})

JuiceZones = lib.zones.poly({
	points = Config.Vineyard.grapejuice.zones,
	thickness = 2,
	debug = Config.Debug,
	onExit = exitZone,
	onEnter = enterZone,
	inside = juiceWork
})

for i, coords in pairs(grapeLocations) do
	grapeZones[i] = lib.zones.box({
		coords = coords,
		size = vec3(1, 1, 1),
		rotation = 40,
		debug = Config.Debug,
		onExit = exitZone,
		onEnter = enterZone,
		inside = toPickGrapes,
	})
end