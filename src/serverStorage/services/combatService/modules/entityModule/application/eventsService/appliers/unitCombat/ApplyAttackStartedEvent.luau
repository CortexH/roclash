local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)


function module.apply(event : eventType.attackStartedEvent, context)
	if event.isValid == false then return end
	
	local unitsBc = context["UnitsBC"]
	local attacker : unitEntity.unitEntity = unitsBc:getActiveUnitById(event.data.attackerId)	
	
	attacker:getAttacker():getState():setAttacking(
		context["TimeBC"].currentTime,
		attacker:getAttacker():getAttackerConfig():getTotalAttackTime()
	)
	
	attacker:getAttacker():getState():setAttacking(context["TimeBC"].currentTime)
	
	event.shouldRender = true
end

return module
