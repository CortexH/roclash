local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local aggroService = require(domain.domainService.AggroDomainService)
local movementService = require(domain.domainService.MovementDomainService)

function module.handle(event : eventType.unitMovementStartedEvent, context)
	if event.isValid == false then return {} end	
	
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	local movementTime = event.data.movementTime

	return {generateMovementResolvedEvent(unit, event.data.finalPosition, movementTime)}
end

function generateMovementResolvedEvent(unit : unitEntity.unitEntity, finalPos, movementTime : number)
	
	local event : eventType.unitMovementResolvedEvent = {
		delay = movementTime,
		type = "EVENT",
		eventType = "UnitMovementResolvedEvent"
	}
	
	event.data = {
		unitId = unit:getId(),
		unitVersion = unit:getAttacker():getVersioning():getMovementVersion(),
		position = finalPos
	}
	
	return event
end

return module
