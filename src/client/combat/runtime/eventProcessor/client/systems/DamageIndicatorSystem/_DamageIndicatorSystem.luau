local module = {}

module.applies = {
	["DamageApplied"] = require(script.Parent.ListenDamageApplied).handle
}

return module
