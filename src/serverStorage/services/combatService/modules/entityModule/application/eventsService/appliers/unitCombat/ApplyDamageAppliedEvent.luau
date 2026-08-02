local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.apply(event : eventType.damageAppliedEvent, context)
	local unitsBC = context["UnitsBC"]
	local target : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.targetId)
	
	target:applyDamage(event.data.damage)
	
	-- Aplica a transição Alive -> Dead imediatamente no estado, para que
	-- danos subsequentes no mesmo frame não gerem novas mortes.
	if target:getHealth() <= 0 and not target:isDead() then
		target:kill()
		target.justDied = true
	end
	
	event.shouldRender = true
end

return module
