local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.handle(event : combatEventTypes.unitMovementSegmentEvent, context)
	
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	local movementTime = movementService.timeToMoveToPosition(unit, event.data.beginPosition, event.data.finalPosition) 
	
	return {
		[1] = generateMovementStartedEvent(unit, event.data.beginPosition, event.data.finalPosition, 0, movementTime, event.data.unitVersion),
		[2] = generateMovementResolvedEvent(unit, event.data.finalPosition, movementTime, event.data.unitVersion)
	}
end

function generateMovementStartedEvent(unit : unitEntity.unitEntity, fromPos, toPos, delay, movementTime, version)
	return {
		delay = delay,
		type = "EVENT",
		eventType = "UnitMovementStartedEvent",
		data = {
			beginPosition = fromPos,
			finalPosition = toPos,
			unitId = unit:getId(),
			unitVersion = version,
			movementTime = movementTime,
			walkSpeed = movementService.getUnitWalkSpeed(unit)
		}
	}
end

function generateMovementResolvedEvent(unit : unitEntity.unitEntity, finalPos, movementTime : number, version)

	local event : eventType.unitMovementResolvedEvent = {
		delay = movementTime,
		type = "EVENT",
		eventType = "UnitMovementResolvedEvent"
	}

	event.data = {
		unitId = unit:getId(),
		unitVersion = version,
		position = finalPos
	}

	return event
end

return module
