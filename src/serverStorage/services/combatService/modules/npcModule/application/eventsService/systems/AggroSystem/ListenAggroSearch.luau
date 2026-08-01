local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)


local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.unitAggroSearchEvent, context)
	if event.isValid == false then return {} end

	local brain = brainPort.getNpcBrain(event.data.aggroingUnitId, context)

	if not brain then return {} end
	if not brain:getAggro() then return {} end

	local bestTarget = aggroService.getBestTarget(event.data.aggroingUnitId, brain, context)
	
	if bestTarget then
		return {{
			delay = 0,
			eventType = "UnitAggroIntentEvent",
			type = "EVENT",
			data = {
				source = event.data.aggroingUnitId,
				target = bestTarget,
				origin = {
					type = "SYSTEM",
					playerId = nil
				},
				policy = "AUTO"
			},
			isValid = true
		}}
	else
		return {eventFactory.createUnitIdleEvent(0, event.data.aggroingUnitId)}
	end
end

return module
