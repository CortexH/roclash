local module = {}

module.applies = {
	["AttackImpactEvent"] = require(script.Parent.ListenImpactResolution.ListenImpactResolution).handle,
	["DamageAppliedEvent"] = require(script.Parent.ListenDamageApplied).handle
}

module.generates = {
	"Generate_DamageAppliedEvent",
	"Generate_UnitDiedEvent"
}

return module
