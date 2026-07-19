local module = {}

module.applies = {
	["TargetAcquiredEvent"] = require(script.Parent.ListenTargetAcquireEvent).handle,
	["CooldownReadyEvent"] = require(script.Parent.ListenCooldownReadyEvent).handle
}

module.generates = {
	"Generate_UnitAttackStartedEvent"
}

return module
