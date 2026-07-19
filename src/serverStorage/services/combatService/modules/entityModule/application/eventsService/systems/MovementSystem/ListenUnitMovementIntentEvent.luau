local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.handle(event : combatEventTypes.unitMovementIntentEvent, context)
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	local generatedEvents = {}
	local accumulatedDelay = 0

	local lastPosition = unit:getPosition():getCurrentPosition(ct)
		
	if not mapPort.isPositionCenteredInCell(lastPosition, event.data.startCell) then
		local movementTime = movementService.timeToMoveToPosition(unit, lastPosition, mapPort.getPositionFromCell(event.data.startCell))
		table.insert(generatedEvents, generateMovementEvent(
			unit, 
			lastPosition, 
			mapPort.getPositionFromCell(event.data.startCell), 
			accumulatedDelay
			))
		accumulatedDelay += movementTime
		lastPosition = mapPort.getPositionFromCell(event.data.startCell)
	end
	
	local lastSegment = nil
	for _, segment in event.data.path do
		local movementTime = movementService.timeToMoveToPosition(unit, lastPosition, mapPort.getPositionFromCell(segment.toCell))
		table.insert(generatedEvents, generateMovementEvent(unit, lastPosition, mapPort.getPositionFromCell(segment.toCell), accumulatedDelay))
		accumulatedDelay += movementTime
		lastPosition = mapPort.getPositionFromCell(segment.toCell)
		
		if segment.blocker then
			table.insert(generatedEvents, eventFactory.createStructureBlockingPathEvent(
				accumulatedDelay,
				unit:getId(),
				segment.blocker
				))
		end
		lastSegment = segment
	end

	if event.data.reachable and lastSegment and not lastSegment.blocker then
		table.insert(generatedEvents, eventFactory.createUnitReachedAggroEvent(
			accumulatedDelay,
			unit:getId(),
			unit:getAttacker():getVersioning():getAggroVersion()
			))
	end
	
	
	return generatedEvents
end

function generateMovementEvent(
	unit : unitEntity.unitEntity,
	fromPos : {X : number, Y : number},
	toPos : {X : number, Y : number},
	delay : number
)
	return {
		delay = delay,
		type = "EVENT",
		eventType = "UnitMovementSegmentEvent",
		data = {
			beginPosition = fromPos,
			finalPosition = toPos,
			unitId = unit:getId(),
			unitVersion = unit:getAttacker():getVersioning():getMovementVersion()
		}
	}
end

return module
