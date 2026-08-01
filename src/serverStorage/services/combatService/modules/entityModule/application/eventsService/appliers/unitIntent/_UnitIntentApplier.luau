local module = {}

module.applies = {
	["AggroIntentAccepted"] = require(script.Parent.ApplyAggroIntentAccepted).apply
}

return module
