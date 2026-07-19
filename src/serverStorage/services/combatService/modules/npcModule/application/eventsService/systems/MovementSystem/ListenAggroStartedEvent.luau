local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local pathService = require(domain.service.PathService)
local mapPort = require(domain.ports.MapPort)

function module.handle(event : combatEventTypes.UnitAggroStartedEvent, context)
	if event.isValid == false then return {} end
	return {eventService.createMovementRequestEvent(
		0, event.data.aggroingUnitId, nil, event.data.aggroedUnitId
		)}
end

return module
