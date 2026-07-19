local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)


function module.apply(event : combatEventTypes.unitSpawnedEvent, context)
	if event.isValid == false then return end

	local brain = brainPort.getNpcBrain(event.data.entityId, context)
	
	local unit = viewPort.getSelfBattleView(event.data.entityId, context)
	
	brain:initTargeting(unit.maxTargets)
	
end

return module
