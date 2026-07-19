local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)


function module.apply(event : eventType.unitDiedEvent, context)
	local unitsBC = context["UnitsBC"]
		
	local target : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.targetId)
	target:kill()
	
	event.shouldRender = true
end

return module
