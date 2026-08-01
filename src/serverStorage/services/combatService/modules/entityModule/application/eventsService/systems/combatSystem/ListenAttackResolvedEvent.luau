local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.handle(event : eventType.attackResolvedEvent, context)
	if event.isValid == false then return {} end

	local unitsBC = context["UnitsBC"]
	local attacker : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.attackerId)
		
	if attacker:isDead() then return {} end
	
	return {generateCooldownReadyEvent(attacker)}
end

function generateCooldownReadyEvent(unit : unitEntity.unitEntity)
	
	local event : eventType.cooldownReadyEvent = {
		delay = unit:getAttacker():getAttackCooldownTime(),
		eventType = "CooldownReadyEvent",
		type = "EVENT",
		data = {
			unitId = unit:getId()
		}
	}
	
	return event
end

return module
