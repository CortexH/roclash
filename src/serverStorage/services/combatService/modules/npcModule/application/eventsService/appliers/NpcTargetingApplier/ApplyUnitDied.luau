local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.apply(event : combatEventTypes.unitDiedEvent, context)
	if event.isValid == false then return {} end	

	local deadUnitId = event.data.targetId

	local allBrains = brainPort.getAllNpcBrains(context)
		
	for _, otherBrain in allBrains do
		otherBrain:getTargeting():removePossibleTarget(deadUnitId)
	end
end

return module
