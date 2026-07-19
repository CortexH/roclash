local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.handle(event : eventType.damageAppliedEvent, context)
	if event.isValid == false then return {} end	

	local unitsBC = context["UnitsBC"]
	
	local target : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.targetId)
	local source = unitsBC:getActiveUnitById(event.data.sourceId)
	
	if target:getHealth() > 0 then return {} end
	
	return {generateUnitDiedEvent(target, source)}
	
end

function generateUnitDiedEvent(unit : unitEntity.unitEntity, source : unitEntity.unitEntity)
	
	local event : eventType.unitDiedEvent = {
		delay = 0,
		eventType = "UnitDiedEvent",
		type = "EVENT",
		data = {
			targetId = unit:getId(),
			sourceId = source:getId()
		}
	}
	
	return event
end

return module
