local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.handle(event : combatEventTypes.unitIdleEvent, context)
	
	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	local isMoving = unit:getPosition():getActiveMovement() ~= nil
	and unit:getPosition():getActiveMovement():isExpired(ct) == false
	
	if not isMoving then return {} end
	
	local movement = unit:getPosition():getActiveMovement()
	
	print(unit:getPosition():getCurrentPosition(ct))
	
	return {generateMovementStopped(
		0, unit, movement.from, movement.to, unit:getPosition():getCurrentPosition(ct)
	)}
	
end

function generateMovementStopped(delay, unit : unitEntity.unitEntity, beginPos, finalPos, currentPos)
	return {
		delay = delay,
		type = "EVENT",
		eventType = "UnitMovementStoppedEvent",
		data = {
			unitCurrentPosition = currentPos,
			movementBeginPosition = beginPos,
			movementFinalPosition = finalPos,
			unitId = unit:getId(),
			movementVersion = unit:getAttacker():getVersioning():getAttackVersion(),
		}
	}
end

return module
