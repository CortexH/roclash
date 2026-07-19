local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)


function module.apply(event : combatEventTypes.unitAggroSearchEvent, context)
	if event.isValid == false then return end

	local brain = brainPort.getNpcBrain(event.data.aggroingUnitId, context)
	if not brain then return end
	if not brain:getAggro() then return end

	local selfView = viewPort.getSelfBattleView(event.data.aggroingUnitId, context)
	if not selfView then return end
	if not selfView.aggroRange then return end
	
	brain:getAggro():clearCandidates()

	local allUnits = context.UnitsBC:getAllActiveUnits()
	
	for _, candidate in pairs(allUnits) do
		local candidateView = viewPort.getUnitBattleView(event.data.aggroingUnitId, candidate.uniqueId, context)
		if candidateView.isEnemy and candidateView.isPlaced and candidateView.isAlive and candidateView.distanceToSelf <= selfView.aggroRange then
			brain:getAggro():addCandidate(candidateView.id, context.TimeBC.currentTime)
		end
	end
end
return module
