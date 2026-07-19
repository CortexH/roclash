local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local combatService = require(domain.domainService.UnitCombatDomainService)

function module.handle(event : eventType.unitMovementResolvedEvent, context)
	if event.isValid == false then return {} end	

	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
		
	if unit:getAttacker():getLastAttackTime() 
		and unit:getAttacker():getLastAttackTime() + 
		unit:getAttacker():getAttackCooldownTime() > context["TimeBC"].currentTime then
		return {}
	end
	
	if unit:getAttacker():getAggro():isUnitAggroing() then
		local target = unitsBC:getActiveUnitById(unit:getAttacker():getAggro():getAggroTargetId())
		if combatService.validateIfUnitIsInAttackRange(unit, target, context["TimeBC"].currentTime) then
			unit:getAttacker():addTarget(target:getId())
			
			return {generateAttackStartedEvent(
				target, unit
			)}
		end
	end
	
	local inRange = combatService.getUnitsInAttackRange(
		unit, 
		unitsBC:getAllActiveUnits(), 
		context["TimeBC"].currentTime
	)
		
	if #inRange < 1 then return {} end

	return {generateAttackStartedEvent(
		inRange[Random.new(context["ConstsBC"]["seed"]):NextInteger(1, #inRange)],
		unit
	)}
	
end

function generateAttackStartedEvent(targetUnit, attackerUnit)

	local event : eventType.attackStartedEvent = {
		delay = 0,
		eventType = "AttackStartedEvent",
		type = "EVENT",
		data = {
			attackerId = attackerUnit:getId(),
			targetId = targetUnit:getId(),
			attackerVersion = attackerUnit:getVersion(),
			targetVersion = targetUnit:getVersion()
		}
	}

	return event

end

return module
