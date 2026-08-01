local module = {}

module.applies = {
	["UnitAggroStartedEvent"] = require(script.Parent.ListenAggroStartedEvent).handle,
	["UnitStructureBlockingPathEvent"] = require(script.Parent.ListenPathBlockedEvent).handle,
	["MovementIntent"] = require(script.Parent.ListenMovementIntent).handle,
	["MovementIntentAccepted"] = require(script.Parent.ListenMovementIntentAccepted).handle
}

module.generates = {
	"Generate_MovementIntent",
	"Generate_MovementIntentAccepted"
}

return module
