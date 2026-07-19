local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.handle(event : combatEventTypes.unitMovementStoppedEvent, context)
	if event.isValid == false then return {} end
	
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	local generatedEvents = {}
	
	local currentPos = event.data.unitCurrentPosition
	
	local fowardCell = mapPort.getForwardCell(
		currentPos,
		event.data.movementBeginPosition,
		event.data.movementFinalPosition
	)
	
	local nextCell = mapPort.getNextAllowedCell(fowardCell, context)
	
	return {generateSegmentRequestEvent(
		unit,
		currentPos,
		mapPort.getPositionFromCell(nextCell),
		0
		)}
end

function generateSegmentRequestEvent(
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
