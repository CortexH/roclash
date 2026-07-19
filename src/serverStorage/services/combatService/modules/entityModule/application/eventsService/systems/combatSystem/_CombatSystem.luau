local module = {}

module.applies = {
	["AttackStartedEvent"] = require(script.Parent.ListenAttackStartedEventCombat.ListenAttackStartedEventCombat).handle,
	["AttackResolvedEvent"] = require(script.Parent.ListenAttackResolvedEvent).handle,
}

module.generates = {
	"Generate_AttackStartedEvent",
	"Generate_ProjectileLaunchedEvent", 
	"Generate_AttackImpactEvent",
	"Generate_AttackResolvedEvent",
	"Generate_CooldownReadyEvent"
}

return module
