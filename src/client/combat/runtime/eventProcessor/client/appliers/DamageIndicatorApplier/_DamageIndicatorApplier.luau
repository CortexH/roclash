local module = {}

module.applies = {
	["DamageIndicatorCreated"] = require(script.Parent.ApplyDamageIndicatorCreated).apply
}

return module
