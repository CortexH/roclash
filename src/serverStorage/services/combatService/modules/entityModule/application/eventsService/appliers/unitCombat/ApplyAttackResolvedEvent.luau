local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.apply(event : eventType.attackResolvedEvent, context)
	if event.isValid == false then return end
	local unitsBC = context["UnitsBC"]
	local attacker : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.attackerId)
	
	attacker:getAttacker():getState():setIdle(context["TimeBC"].currentTime)
	attacker:getAttacker():setLastAttackTime(context["TimeBC"].currentTime)
	
end

return module
