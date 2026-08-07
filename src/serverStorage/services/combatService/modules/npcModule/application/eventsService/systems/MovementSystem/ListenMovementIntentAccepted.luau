local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.MoveIntentEvent)
local eventService = require(domain.service.NpcEventFactory)

local viewPort = require(domain.ports.BattleViewPort)
local mapPort = require(domain.ports.MapPort)

local pathService = require(domain.service.PathService)

-- MoveIntentAcceptedHandler
-- Responsável por transformar um Intent aceito em um planejamento de movimento.
-- Executa o algoritmo A*, gera o caminho, identifica blockers e emite um UnitMovementPlanningEvent.
-- Não aplica estado ao mundo.
function module.handle(event : intentTypes.MoveIntentAccepted, context)
	if event.isValid == false then return {} end

	local unit = viewPort.getSelfBattleView(event.data.unitId, context)
	if not unit then return {} end

	local targetCell = event.data.targetCell
	local toTargetCell

	if event.data.targetUnit then
		targetCell = mapPort.getNearestPossibleCell(event.data.unitId, event.data.targetUnit, context)

		local targetView = viewPort.getSelfBattleView(event.data.targetUnit, context)
		if targetView then
			toTargetCell = targetView.currentCell
		end
	end

	if not targetCell then return {} end

	local path = pathService.AStarPathRequest(
		{
			unitId = event.data.unitId,
			fromCell = unit.currentCell,
			toCell = targetCell,
			toTargetCell = toTargetCell,
		},
		context
	)

	if path == nil then return {} end

	return {eventService.createUnitMovementPlanningEvent(
		0,
		event.data.unitId,
		unit.currentCell,
		path.path,
		path.reachable
	)}
end

return module