local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.MoveIntentEvent)
local eventService = require(domain.service.NpcEventFactory)

local viewPort = require(domain.ports.BattleViewPort)
local mapPort = require(domain.ports.MapPort)
local brainPort = require(domain.ports.NpcBrainPort)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

function module.handle(event : intentTypes.MoveIntent, context)
	if event.isValid == false then return {} end

	local self = viewPort.getSelfBattleView(event.data.unitId, context)

	if not self or not self.isAlive then
		return {generateFail(event, context, "DEAD_UNIT")}
	end

	-- Validações de origem do jogador (command). Intents de NPC não passam por aqui.
	local origin = event.data.origin
	if origin and origin.type == "PLAYER" then
		if not self.isPlaced then return {generateFail(event, context, "NOT_PLACED")} end
		if not self.canMove then return {generateFail(event, context, "CANNOT_MOVE")} end
		if tostring(self.owner) ~= tostring(origin.playerId) then return {generateFail(event, context, "NOT_OWNER")} end
	end

	local targetCell = event.data.targetCell

	if event.data.targetUnit then
		targetCell = mapPort.getNearestPossibleCell(event.data.unitId, event.data.targetUnit, context)
	end

	if not targetCell then
		return {generateFail(event, context, "INVALID_TARGET")}
	end

	-- Comando do jogador: rejeita célula não walkable (ex: ocupada por outra unit),
	-- evitando que o A* tente planejar um caminho para uma posição inalcançável.
	if origin and origin.type == "PLAYER" and event.data.targetUnit == nil then
		if not mapPort.isCellWalkable(targetCell, context) then
			return {generateFail(event, context, "INVALID_POSITION")}
		end
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

	local generatedEvents = {}

	-- Comando do jogador: o movimento manual cancela o aggro e o targeting atuais.
	-- A unit passa a obedecer o movimento manual e não busca novo aggro enquanto
	-- estiver se movendo (ver ListenAggroSearch). Ao terminar o movimento, o
	-- VerifyAggroReachedEvent retoma a busca de aggro.
	if origin and origin.type == "PLAYER" then
		local brain = brainPort.getNpcBrain(event.data.unitId, context)
		if brain and brain:getAggro() then
			local currentAggro = brain:getAggro():getCurrentAggro()
			if currentAggro then
				brain:setManualMoving(true)
				table.insert(generatedEvents, eventService.createUnitAggroStoppedEvent(0, event.data.unitId, currentAggro))
				table.insert(generatedEvents, eventService.targetLost(0, event.data.unitId, currentAggro))
			end
		end
	end

	table.insert(generatedEvents, generateAccept(event, context))
	return generatedEvents
end

function generateFail(event, context, type)
	return eventService.createMoveIntentRejected(
		0,
		event.data.unitId,
		event.data.targetCell,
		event.data.targetUnit,
		type,
		event.data.origin
	)
end

function generateAccept(event, context)
	return eventService.createMoveIntentAccepted(
		0,
		event.data.unitId,
		event.data.targetCell,
		event.data.targetUnit,
		event.data.reason,
		event.data.origin
	)
end

return module