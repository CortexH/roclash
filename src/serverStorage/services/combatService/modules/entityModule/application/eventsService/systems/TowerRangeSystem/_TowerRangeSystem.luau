local module = {}

module.applies = {
	["UnitSpawnedEvent"] = require(script.Parent.ListenUnitSpawnedTowerRange).handle,
	["UnitMovementStartedEvent"] = require(script.Parent.ListenUnitMovementStartedTowerRangeSystem).handle,
}

module.generates = {
	"Generate_UnitEnteredTowerRangeEvent",
	"Generate_UnitLeftTowerRangeEvent"
}

return module
