local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.handle(
	source : unitEntity.unitEntity, 
	target : unitEntity.unitEntity, 
	impactNumber,
	context,
	impactPosition : Vector2
)
	
	local unitsBC = context["UnitsBC"]
	local attackerConfig = source:getAttacker():getAttackerConfig()
	
	local events = {}
	
	for _, unit : unitEntity.unitEntity in unitsBC:getAllActiveUnits() do
		if unit:getParty() == source:getParty() then continue end
		if unit:isDead() then continue end
		
		local distance = unit:getPosition():getCurrentPosition(context["TimeBC"].currentTime)
		:distanceTo(impactPosition)
				
		if distance <= attackerConfig:getImpactSize() then
			table.insert(events, generateEvent(
				source:getId(),
				unit:getId(),
				source:getAttacker():getDamage(), -- TODO: ajustar para mudar tipo de dano ao impacto multihits
				source:getAttacker():getAttackerConfig():getDamageType(),
				0
				))
		end
	end
		
	return events
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
