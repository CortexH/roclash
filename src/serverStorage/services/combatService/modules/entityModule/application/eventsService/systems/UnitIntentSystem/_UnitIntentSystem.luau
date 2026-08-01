local module = {}

module.applies = {
	["AggroIntentAccepted"] = require(script.Parent.Unit_AggroIntentAccept).handle,
	["AttackIntentAccepted"] = require(script.Parent.Unit_AttackIntentAccept).handle
}

module.generates = {
	
}


return module
