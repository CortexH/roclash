local module = {}

module.applies = {
	["UnitMoveCommand"] = require(script.Parent.ListenUnitMoveCommand).handle,
	--["UnitMovementStartedEvent"] = require(script.Parent.ListenMovementStartedMovement).handle,
	["UnitMovementPlanningEvent"] = require(script.Parent.ListenUnitMovementPlanningEvent).handle,
	["UnitMovementIntentEvent"] = require(script.Parent.ListenUnitMovementIntentEvent).handle,
	["UnitMovementSegmentEvent"] = require(script.Parent.ListenMovementSegment).handle,
	["UnitMovementStoppedEvent"] = require(script.Parent.ListenUnitMovementStoppedEvent).handle,
	["UnitIdleEvent"] = require(script.Parent.ListenUnitIdle).handle
}

module.generates = {
	"Generate_UnitMovementStartedEvent",
	"Generate_UnitMovementResolvedEvent",
	"Generate_UnitMoveCommandResponse",
	"Generate_UnitStructureBlockingPathEvent"
}

return module
