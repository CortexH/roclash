local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.apply(event : combatEventTypes.UnitAggroStartedEvent, context)
	if event.isValid == false then return end

	local brain = brainPort.getNpcBrain(event.data.aggroingUnitId, context)
	if not brain then return end
	if not brain:getAggro() then return end

	brain:getAggro():setAggro(event.data.aggroedUnitId)
end

return module
