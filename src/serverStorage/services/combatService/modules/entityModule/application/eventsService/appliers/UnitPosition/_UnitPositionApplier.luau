local module = {}


function applyUnitPositionChangedEvent(event, context)
	
end

function applyUnitTeleportedEvent(event, context)
	
end

module.applies = {
	["UnitPositionChangedEvent"] = applyUnitPositionChangedEvent,
	["UnitTeleportedEvent"] = applyUnitTeleportedEvent,
	["UnitMovementResolvedEvent"] = require(script.Parent.ApplyMovementResolvedEvent).apply,
	["UnitMovementStartedEvent"] = require(script.Parent.ApplyMovementStartedEvent).apply,
	["UnitMovementInterruptedEvent"] = require(script.Parent.ApplyMovementInterruptedEvent).apply,
	["UnitMovementStoppedEvent"] = require(script.Parent.ApplyMovementStoppedEvent).apply
}

return module
