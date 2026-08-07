local module = {}

module.applies = {
	--["UnitMovementStartedEvent"] = require(script.Parent.ListenMovementStartedMovement).handle,
	["UnitMovementPlanningEvent"] = require(script.Parent.ListenUnitMovementPlanningEvent).handle,
	["UnitMovementSegmentEvent"] = require(script.Parent.ListenMovementSegment).handle,
	["UnitMovementStoppedEvent"] = require(script.Parent.ListenUnitMovementStoppedEvent).handle,
	["UnitIdleEvent"] = require(script.Parent.ListenUnitIdle).handle
}

module.generates = {
	"Generate_UnitMovementStartedEvent",
	"Generate_UnitMovementResolvedEvent",
	"Generate_UnitStructureBlockingPathEvent"
}

return module
