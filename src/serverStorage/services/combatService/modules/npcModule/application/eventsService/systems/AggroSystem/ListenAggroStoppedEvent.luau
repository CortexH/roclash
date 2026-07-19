local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.unitAggroStoppedEvent, context)
	if event.isValid == false then return {} end

	local brain = brainPort.getNpcBrain(event.data.aggroingUnitId, context)
	
	if not brain then return {} end
	if not brain:getAggro() then return {} end
	
	return { eventService.createUnitAggroSearchEvent(
		0,
		event.data.aggroingUnitId
		)}
end

return module
