local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local pathService = require(domain.service.PathService)
local mapPort = require(domain.ports.MapPort)

function module.handle(event : combatEventTypes.unitStructureBlockingPathEvent, context)
	if event.isValid == false then return {} end
	
	local blocker = viewPort.getUnitBattleView(event.data.unitId, event.data.blockerId, context)
	
	if not blocker then return {} end
	if blocker.isAlive then return {} end
	
	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	if not brain then return {} end
	
	local currentAggro = brain:getAggro():getCurrentAggro()
	if currentAggro then

		return { eventService.createMoveIntent(
			0, event.data.unitId, nil, currentAggro, "PATH_BLOCKED"
			) }
	end

	return { 
		eventService.createUnitIdleEvent(0, event.data.unitId) 
	}
end

return module
