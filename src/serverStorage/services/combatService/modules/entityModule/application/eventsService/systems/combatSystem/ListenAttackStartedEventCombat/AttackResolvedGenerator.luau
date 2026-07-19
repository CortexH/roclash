local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local towerDomainService = require(domain.domainService.TowerDomainService)
local mathService = require(domain.domainService.MathService)

local attackerConfig = require(domain.entity.UnitEntityAgg.AttackerUnitAgg.AttackerConfig)


function module.generate(
	event : eventType.attackStartedEvent, context
)
	
	local unitsBC = context["UnitsBC"]
	local attacker : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.attackerId)
	
	local attackerConfig = attacker:getAttacker():getAttackerConfig()
	
	local event : eventType.attackResolvedEvent = {
		eventType = "AttackResolvedEvent",
		delay = attackerConfig:getTotalAttackTime(),
		type = "EVENT",
		data = {
			attackerId = attacker:getId()
		}
	}
	
	return event
	
end



return module
