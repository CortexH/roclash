local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.MovementIntentEvent)
local eventService = require(domain.service.NpcEventFactory)

local viewPort = require(domain.ports.BattleViewPort)
local mapPort = require(domain.ports.MapPort)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

function module.handle(event : intentTypes.MovementIntent, context)
	if event.isValid == false then return {} end

	local self = viewPort.getSelfBattleView(event.data.unitId, context)

	if not self or not self.isAlive then
		return {generateFail(event, context, "DEAD_UNIT")}
	end

	local targetCell = event.data.targetCell

	if event.data.targetUnit then
		targetCell = mapPort.getNearestPossibleCell(event.data.unitId, event.data.targetUnit, context)
	end

	if not targetCell then
		return {generateFail(event, context, "INVALID_TARGET")}
	end

	if self.currentCell.x == targetCell.x and self.currentCell.y == targetCell.y then
		-- A unit já está na célula alvo. Se existe uma Wall separando-a do target
		-- (ex: unit colada na parede da Tower), não rejeita: delega diretamente ao
		-- fluxo canônico de blocker, sem depender do VerifyAggroReached.
		if event.data.targetUnit then
			local targetView = viewPort.getSelfBattleView(event.data.targetUnit, context)
			if targetView then
				local hasWall, wallId = mapPort.hasWallToward(self.currentCell, targetView.currentCell, context)
				if hasWall then
					return { eventFactory.createStructureBlockingPathEvent(0, event.data.unitId, wallId) }
				end
			end
		end

		return {generateFail(event, context, "ALREADY_AT_TARGET")}
	end

	return {generateAccept(event, context)}
end

function generateFail(event, context, type)
	return eventService.createMovementIntentRejected(
		0,
		event.data.unitId,
		event.data.targetCell,
		event.data.targetUnit,
		type
	)
end

function generateAccept(event, context)
	return eventService.createMovementIntentAccepted(
		0,
		event.data.unitId,
		event.data.targetCell,
		event.data.targetUnit,
		event.data.reason
	)
end

return module