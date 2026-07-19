local module = {}

function applyUnitAggroStoppedEvent(event, context)
	
end

module.applies = {
	["AttackStartedEvent"] = require(script.Parent.ApplyAttackStartedEvent).apply,
	["AttackResolvedEvent"] = require(script.Parent.ApplyAttackResolvedEvent).apply,
	["DamageAppliedEvent"] = require(script.Parent.ApplyDamageAppliedEvent).apply,
	["AttackImpactEvent"] = require(script.Parent.ApplyAttackImpactEvent).apply,
	["ProjectileLaunchedEvent"] = require(script.Parent.ApplyProjectileLaunchedEvent).apply,
}

return module
