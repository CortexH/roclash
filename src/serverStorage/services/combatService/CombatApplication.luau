local service = {}

local httpService = game:GetService("HttpService")
local rs = game:GetService("RunService")

local queueApp = require(script.Parent.QueueApplication)

local battleContext = require(script.Parent.battleContext.BattleContext)

local activeBattles = require(script.Parent.ActiveBattles)
local activeQueues = require(script.Parent.ActiveQueues)

local moduleConsts = require(game.ServerStorage.Server.constants.CombatServiceModulesConsts)

local renderPipeline = require(game.ServerStorage.Server.services.combatService.pipelines.RenderPipeline._RenderPipeline)
local interactionPipeline = require(game.ServerStorage.Server.services.combatService.pipelines.InteractionPipeline._InteractionPipeline)
local uiStatePipeline = require(game.ServerStorage.Server.services.combatService.pipelines.UIStatePipeline._UIStatePipeline)
local endpoints = require(game.ServerStorage.Server.services.combatService.API.frontEnd.Remotes)

function service.beginCombat(playerId : number, opponentId : number, snapshotNumber : number, attackerData)
	local battleId = httpService:GenerateGUID(false)
	local context = battleContext.new(playerId, opponentId, snapshotNumber, attackerData, battleId)

	activeBattles.addActiveBattle(context["IdentityBC"]["attackerPlayerId"], context)

	setup(context, attackerData)
	print(context)
	return os.clock()
end

function service.beginSimulation(context)
	local currentTime = os.clock()

	local queue = queueApp.new(context["IdentityBC"]["attackerPlayerId"], currentTime)
	context["EventQueueBC"]["events"] = queue.events
	context["EventQueueBC"]["consumedEvents"] = queue.consumedEvents

	activeQueues.addActiveQueue(context["IdentityBC"]["attackerPlayerId"], queue)
end

function service.endCombat(playerId : number)
	
end

rs.Heartbeat:Connect(function(dt)
	local currentTime = os.clock()
	for _, v in pairs(activeBattles.getActiveBattles()) do
		if v["BattleStateBC"].status ~= "RUNNING" then continue end

		v["TimeBC"].currentTime = currentTime
		local queue = activeQueues.getActiveQueue(v["IdentityBC"]["attackerPlayerId"])
		
		queue:advanceTo(currentTime, function(event)
			v["TimeBC"].currentTime = event.time
			
			local targetQueue = v["IdentityBC"]["attackerPlayerId"]
			queueApp.processEvent(event, targetQueue, v)
						
		end)
		
		if #queue:getAllRuntimeEvents() > 0 then
			print("------------------------------------------------")
		end
		
		local events = {}

		local renderEvents = renderPipeline.renderEvents(queue:getAllRuntimeEvents(), currentTime, v["IdentityBC"]["attackerPlayerId"])
		local interactionEvents = interactionPipeline.updatePlayerState(queue:getAllRuntimeEvents(), currentTime)
		local uiStateEvents = uiStatePipeline.process(v, queue:getAllRuntimeEvents(), currentTime)
		
		for _, currentEvent in pairs(renderEvents) do
			table.insert(events, currentEvent)
		end

		for _, currentEvent in pairs(interactionEvents) do
			table.insert(events, currentEvent)
		end

		for _, currentEvent in pairs(uiStateEvents) do
			table.insert(events, currentEvent)
		end

		if #events > 0 then
			endpoints.data.toFront.packetsEvent:FireClient(game:GetService("Players"):GetPlayerByUserId(v["IdentityBC"]["attackerPlayerId"]), events, currentTime)
		end

	end
end)

local mapModule = require(moduleConsts.paths.mapModule.MapModule)
local entityModule = require(moduleConsts.paths.entityModule.EntityModule)
local npcModule = require(moduleConsts.paths.npcModule.NpcModule)
local gameMOdule = require(moduleConsts.paths.gameModule.GameModule)
local InteractionModule = require(moduleConsts.paths.interactionModule.InteractionModule)

local gameModuleAPI = require(game.ServerStorage.Server.services.combatService.API.gameModule.GameModuleDataAPI)

function setup(context, attackerData)
	local mapBruteData = mapModule.loadMapData(context)
	mapModule.updateContextData(context)
	entityModule.loadEntities(context, mapBruteData, attackerData)
	gameModuleAPI.sendPlayerFirstData(context)
end

local queueAPI = require(game.ServerStorage.Server.services.combatService.API.eventQueue.EnqueueEvent)

require(game.ServerStorage.Server.services.combatService.API.frontEnd.Remotes).runtime.StartBattle.OnServerEvent:Connect(function(player : Player)
	local context = activeBattles.getActiveBattle(player.UserId)
	
	if context["BattleStateBC"]:getStatus() == "RUNNING" then return end
	service.beginSimulation(context)
	context["BattleStateBC"]:setStatus("RUNNING")

	local event = {
		delay = 0,
		eventType = "BeginGameEvent",
		shouldRender = true
	}

	local request : queueAPI.request = {
		targetQueue = tostring(player.UserId),
		event = event
	}
	
	queueAPI.enqueueEvent(request)
end)

require(script.Parent.UserInputReceiver)

return service
