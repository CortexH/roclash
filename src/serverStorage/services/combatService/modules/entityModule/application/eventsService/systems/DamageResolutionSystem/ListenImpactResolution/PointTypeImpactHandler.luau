local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)


function module.handle(
	source : unitEntity.unitEntity, 
	target : unitEntity.unitEntity, 
	impactNumber)
	
	if target:isDead() then return nil end
	local damage = source:getAttacker():getDamage()
	
	return {generateEvent(
		source:getId(),
		target:getId(),
		damage,
		source:getAttacker():getAttackerConfig():getDamageType(),
		0
	)}
	
end

function generateEvent(sourceId, targetId, damage, sourceDamageType, delay)
	local event : eventType.damageAppliedEvent = {
		delay = delay,
		eventType = "DamageAppliedEvent",
		type = "EVENT",
		data = {
			sourceId = sourceId,
			targetId = targetId,
			damage = damage,
			sourceDamageType = sourceDamageType
		}
	}
	
	return event
end

return module
