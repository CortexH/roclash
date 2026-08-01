local module = {}

module.applies = {
	["TargetAcquiredEvent"] = require(script.Parent.ListenTargetAcquireEvent).handle,
	["CooldownReadyEvent"] = require(script.Parent.ListenCooldownReadyEvent).handle,
	["AttackIntent"] = require(script.Parent.ListenAttackIntentEvent).handle, -- Adicionado
	["AttackIntentFailed"] = require(script.Parent.ListenAttackIntentFailed).handle -- Adicionado
}

module.generates = {
	"Generate_UnitAttackStartedEvent",
	"Generate_AttackIntent"
}

return module

