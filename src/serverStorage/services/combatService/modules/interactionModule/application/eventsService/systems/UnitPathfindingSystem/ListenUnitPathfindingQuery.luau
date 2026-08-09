local module = {}

local query = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.queries.UnitPathfindingQuery)

local npcDomain = game.ServerStorage.Server.services.combatService.modules.npcModule.domain
local viewPort = require(npcDomain.ports.BattleViewPort)
local pathService = require(npcDomain.service.PathService)

-- Limite de distância Manhattan entre origem e goal.
-- Proteção contra goals fora do mapa (células infinitas) que travariam o A*.
local MAX_PATH_DISTANCE = 200

-- UnitPathfindingQueryHandler
-- Consulta o pathfinding existente (PathService) e devolve o caminho calculado.
-- NÃO executa movimentação: apenas responde "qual seria o caminho?".
function module.handle(event : query.UnitPathfindingQuery, context)
	local unitId = event.data.unitId

	local unit = viewPort.getSelfBattleView(unitId, context)
	if not unit then
		return {generateFail(event, "UNIT_NOT_FOUND")}
	end

	local fromCell = unit.currentCell or event.data.start
	local goal = event.data.goal

	if not goal then
		return {generateFail(event, "INVALID_GOAL")}
	end

	-- Rejeita goals muito distantes (fora do mapa) para evitar timeout no A*.
	local distance = math.abs(goal.x - fromCell.x) + math.abs(goal.y - fromCell.y)
	if distance > MAX_PATH_DISTANCE then
		return {generateFail(event, "GOAL_OUT_OF_BOUNDS")}
	end

	local result = pathService.AStarPathRequest(
		{
			unitId = unitId,
			fromCell = fromCell,
			toCell = goal,
		},
		context
	)

	if result == nil then
		return {generateFail(event, "PATH_NOT_FOUND")}
	end

	return {generateSuccess(event, fromCell, goal, result)}
end

function generateSuccess(event : query.UnitPathfindingQuery, start, goal, result)
	return {
		eventType = "UnitPathfindingQuerySuccess",
		type = "QUERY",
		delay = 0,
		signature = event.signature,
		requesterId = event.requesterId,
		data = {
			unitId = event.data.unitId,
			start = start,
			goal = goal,
			path = result.path,
			reachable = result.reachable
		}
	}
end

function generateFail(event : query.UnitPathfindingQuery, reason : string)
	return {
		eventType = "UnitPathfindingQueryFailure",
		type = "QUERY",
		delay = 0,
		signature = event.signature,
		requesterId = event.requesterId,
		data = {
			unitId = event.data.unitId,
			reason = {
				message = reason,
				type = reason
			}
		}
	}
end

return module
