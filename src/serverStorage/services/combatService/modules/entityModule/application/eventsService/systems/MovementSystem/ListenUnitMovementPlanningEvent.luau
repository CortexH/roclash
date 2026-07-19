local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)


function module.handle(event : combatEventTypes.unitMovementPlanningEvent, context)
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	local generatedEvents = {}
	
	local currentPos = unit:getPosition():getCurrentPosition(ct)
	table.insert(generatedEvents, eventFactory.createMovementInterruptedEvent(
		0,
		unit:getId(),
		unit:getAttacker():getVersioning():getMovementVersion(),
		currentPos
		))
	
	table.insert(generatedEvents, eventFactory.createUnitMovementIntentEvent(
		0, event.data.unitId,
		event.data.startCell, event.data.path,
		event.data.reachable
		))
		
	return generatedEvents
	
end

return module
