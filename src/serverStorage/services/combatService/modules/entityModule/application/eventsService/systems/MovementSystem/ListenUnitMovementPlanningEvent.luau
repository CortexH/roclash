local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

-- ListenUnitMovementPlanningEvent
-- Handler responsável por transformar o planejamento em eventos da simulação.
-- Percorre o caminho calculado e gera todos os MovementStartedEvent e MovementFinishedEvent,
-- mantendo exatamente o comportamento atual da movimentação.
-- Após o último MovementFinishedEvent, emite um VerifyAggroReachedEvent.
function module.handle(event : combatEventTypes.unitMovementPlanningEvent, context)
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	local generatedEvents = {}
	local accumulatedDelay = 0

	local movementVersion = unit:getAttacker():getVersioning():getMovementVersion()

	local lastPosition = unit:getPosition():getCurrentPosition(ct)

	if not mapPort.isPositionCenteredInCell(lastPosition, event.data.startCell) then
		local movementTime = movementService.timeToMoveToPosition(unit, lastPosition, mapPort.getPositionFromCell(event.data.startCell))
		table.insert(generatedEvents, generateMovementStartedEvent(
			unit,
			lastPosition,
			mapPort.getPositionFromCell(event.data.startCell),
			accumulatedDelay,
			movementTime
		))
		table.insert(generatedEvents, generateMovementResolvedEvent(
			unit,
			mapPort.getPositionFromCell(event.data.startCell),
			accumulatedDelay,
			movementTime
		))
		accumulatedDelay += movementTime
		lastPosition = mapPort.getPositionFromCell(event.data.startCell)
	end

	if #event.data.path == 0 then
		table.insert(generatedEvents, eventFactory.createVerifyAggroReachedEvent(
			accumulatedDelay,
			unit:getId(),
			movementVersion
		))

		return generatedEvents
	end

	for _, segment in event.data.path do
		local movementTime = movementService.timeToMoveToPosition(unit, lastPosition, mapPort.getPositionFromCell(segment.toCell))
		table.insert(generatedEvents, generateMovementStartedEvent(
			unit,
			lastPosition,
			mapPort.getPositionFromCell(segment.toCell),
			accumulatedDelay,
			movementTime
		))
		table.insert(generatedEvents, generateMovementResolvedEvent(
			unit,
			mapPort.getPositionFromCell(segment.toCell),
			accumulatedDelay,
			movementTime
		))
		accumulatedDelay += movementTime
		lastPosition = mapPort.getPositionFromCell(segment.toCell)

		if segment.blocker then
			table.insert(generatedEvents, eventFactory.createStructureBlockingPathEvent(
				accumulatedDelay,
				unit:getId(),
				segment.blocker
			))
		end
	end

	-- Após o último MovementFinishedEvent, emite VerifyAggroReachedEvent.
	table.insert(generatedEvents, eventFactory.createVerifyAggroReachedEvent(
		accumulatedDelay,
		unit:getId(),
		movementVersion
	))

	return generatedEvents
end

function generateMovementStartedEvent(
	unit : unitEntity.unitEntity,
	fromPos : {X : number, Y : number},
	toPos : {X : number, Y : number},
	delay : number,
	movementTime : number
)
	return {
		delay = delay,
		type = "EVENT",
		eventType = "UnitMovementStartedEvent",
		data = {
			beginPosition = fromPos,
			finalPosition = toPos,
			unitId = unit:getId(),
			unitVersion = unit:getAttacker():getVersioning():getMovementVersion(),
			movementTime = movementTime,
			walkSpeed = movementService.getUnitWalkSpeed(unit)
		}
	}
end

function generateMovementResolvedEvent(
	unit : unitEntity.unitEntity,
	finalPos : {X : number, Y : number},
	delay : number,
	movementTime : number
)
	return {
		delay = delay + movementTime,
		type = "EVENT",
		eventType = "UnitMovementResolvedEvent",
		data = {
			unitId = unit:getId(),
			unitVersion = unit:getAttacker():getVersioning():getMovementVersion(),
			position = finalPos
		}
	}
end

return module
