local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.unitSpawnedEvent, context)
	if event.isValid == false then return {} end
	if event.data.type.unitType ~= "NPC" then return {} end

	local brain = brainPort.getNpcBrain(event.data.entityId, context)
	if not brain then return {} end
	local self = viewPort.getSelfBattleView(event.data.entityId, context)
	
	if self.aggroBehavior ~= "AGGRESSIVE" then return {} end
	
	return {eventService.createUnitAggroSearchEvent(0, event.data.entityId)}
end

return module
