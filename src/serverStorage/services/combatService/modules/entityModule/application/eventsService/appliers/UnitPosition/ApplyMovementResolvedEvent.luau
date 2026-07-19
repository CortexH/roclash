local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementVo = require(domain.valueObjects.UnitMovement)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.apply(event : eventType.unitMovementResolvedEvent, context)
	if event.isValid == false then return {} end

	local unitsBC = context["UnitsBC"]
	
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	unitsBC:unitChangedPosition(unit:getCurrentCell(), event.data.position, event.data.unitId)
	
	unit:getPosition():setCurrentPosition(event.data.position)
	unit:getPosition():clearActiveMovement()
	
	unit:setCurrentCell(mapPort.getCellFromPosition(event.data.position))
	
	unit:getAttacker():getState():setIdle(context["TimeBC"].currentTime)
end

return module
