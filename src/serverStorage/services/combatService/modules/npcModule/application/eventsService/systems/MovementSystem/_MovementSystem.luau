local module = {}

module.applies = {
	["UnitAggroStartedEvent"] = require(script.Parent.ListenAggroStartedEvent).handle,
	["UnitStructureBlockingPathEvent"] = require(script.Parent.ListenPathBlockedEvent).handle,
	["UnitMovementRequestedEvent"] = require(script.Parent.ListenMovementRequestEvent).handle
}

module.generates = {
	"Generate_UnitMovementIntentEvent"
}

return module
