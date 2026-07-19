local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementVo = require(domain.valueObjects.UnitMovement)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.apply(event : eventType.unitMovementStartedEvent, context)
	if event.isValid == false then return end
	local unitsBC = context["UnitsBC"]
	
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
		
	local movement = movementVo.new(
		event.data.beginPosition, 
		event.data.finalPosition, 
		event.data.movementTime,
		event.time
	)
	
	unit:getPosition():setActiveMovement(movement)
	unit:getAttacker():getState():setWalking(context["TimeBC"].currentTime)
	event.shouldRender = true
end

return module
