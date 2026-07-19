local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

local mapAPI = require(domain.ports.gateways.MapGatewayPort)

function module.apply(event : eventType.unitSpawnedEvent, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getReservedUnitById(event.data.entityId)
	
	local suc, err = unit:place(
		event.data.position,
		0,
		mapAPI.getPositionFromCell(event.data.position), 
		event.data.behavior
	)
		
	unitsBC:promoteReservedUnitToActiveUnit(unit:getId())
	
	if unit:getAttacker() then
		unit:getAttacker():getState():setIdle(context["TimeBC"].currentTime)
	end
	event.shouldRender = true
	
end

return module
