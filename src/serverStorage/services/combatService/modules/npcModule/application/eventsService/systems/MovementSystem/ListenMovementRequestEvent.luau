local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local pathService = require(domain.service.PathService)
local mapPort = require(domain.ports.MapPort)

function module.handle(event : combatEventTypes.unitMovementRequestedEvent, context)
	if event.isValid == false then return {} end
	local unit = viewPort.getSelfBattleView(event.data.unitId, context)
		
	local targetCell
	local unitView = viewPort.getSelfBattleView(event.data.unitId, context)

	if event.data.targetUnit ~= nil then
		targetCell = mapPort.getNearestPossibleCell(event.data.unitId, event.data.targetUnit, context)
	elseif event.data.targetCell ~= nil then
		targetCell = event.data.targetCell
	end
	
	local path = pathService.AStarPathRequest(
		{unitId = event.data.unitId, fromCell = unitView.currentCell, toCell = targetCell},
		context
	)	

	if path == nil then return {} end
		
	return {eventService.createUnitMovementPlanningEvent(0,
		event.data.unitId,
		unit.currentCell,
		path.path,
		path.reachable
		)}

	
end

return module
