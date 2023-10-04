local blip = 0
local winetimer = Config.wineTimer
local grapeLocations = Config.grapeLocations
local loadIngredients = false
local wineStarted = false
local finishedWine = false

local function deleteBlip()
	if not DoesBlipExist(blip) then return end
	RemoveBlip(blip)
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
        TriggerServerEvent("qb-vineyard:server:getGrapes")
		deleteBlip()
	else
		exports.qbx_core:Notify(Lang:t('task.cancel_task'), 'error')
	end
	ClearPedTasks(cache.ped)
end

local function pickAnim()
    lib.requestAnimDict('amb@prop_human_bum_bin@idle_a')
    TaskPlayAnim(cache.ped, 'amb@prop_human_bum_bin@idle_a', 'idle_a', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local function exitZone()
	if not Config.Debug then return end
	exports.qbx_core:Notify('Zone Exited', 'inform')
	lib.hideTextUI()
end

local function enterZone()
	if not Config.Debug then return end
	exports.qbx_core:Notify('Zone Entered', 'inform')
end

local function toPickGrapes()
	lib.showTextUI(Lang:t("task.start_task"), {position = 'right'})
	if not IsPedInAnyVehicle(cache.ped) and IsControlJustReleased(0, 38) then
		pickAnim()
		pickProcess()
		lib.hideTextUI()
		random = 0
	end
end

local function startWineProcess()
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


local function prepareAnim()
    lib.requestAnimDict('amb@code_human_wander_rain@male_a@base')
    TaskPlayAnim(cache.ped, 'amb@code_human_wander_rain@male_a@base', 'static', 6.0, -6.0, -1, 47, 0, 0, 0, 0)
end

local function grapeJuiceProcess()
	if lib.progressCircle({
		duration = math.random(15000, 20000),
		label = Lang:t('progress.process_grapes'),
		useWhileDead = false,
		canCancel = true,
		disable = {
			move = true,
			car = true,
			mouse = false,
			combat = true
		}
	}) then
		TriggerServerEvent("qb-vineyard:server:receiveGrapeJuice")
	else
		exports.qbx_core:Notify(Lang:t('task.cancel_task'), 'error')
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
			startWineProcess()
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
	if IsControlJustReleased(0, 38) then
		lib.callback('qb-vineyard:server:loadIngredients', false, function(result)
			if result then loadIngredients = true end
		end)
	end
end

local function juiceWork()
	if IsControlJustReleased(0, 38) then
		lib.callback('qb-vineyard:server:grapeJuice', false, function(result)
			if result then
                prepareAnim()
                grapeJuiceProcess()
            end
		end)
		return false
	end
	return true
end

lib.zones.poly({
	points = Config.Vineyard.wine.zones,
	thickness = 2,
	debug = Config.Debug,
	onExit = exitZone,
	onEnter = enterZone,
	inside = workWine
})

lib.zones.poly({
	points = Config.Vineyard.grapejuice.zones,
	thickness = 2,
	debug = Config.Debug,
	onExit = exitZone,
	onEnter = enterZone,
	inside = juiceWork
})

for _, coords in pairs(grapeLocations) do
	lib.zones.box({
		coords = coords,
		size = vec3(1, 1, 1),
		rotation = 40,
		debug = Config.Debug,
		onExit = exitZone,
		onEnter = enterZone,
		inside = toPickGrapes,
	})
end
