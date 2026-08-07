local module = {}

module.applies = {
	["AggroIntentAccepted"] = require(script.Parent.ApplyAggroIntentAccepted).apply,
	["MoveIntentAccepted"] = require(script.Parent.ApplyMoveIntentAccepted).apply
}

return module
