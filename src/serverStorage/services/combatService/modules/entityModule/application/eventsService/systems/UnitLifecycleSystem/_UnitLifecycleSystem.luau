local module = {}

module.applies = {
	["UnitPlacementCommand"] = require(script.Parent.ListenUnitPlacementCommand).handle,
	["BeginGameEvent"] = require(script.Parent.ListenGameBegin).handle
}

module.generates = {
	"Generate_UnitPlacementCommandResponse",
	"Generate_UnitSpawnedEvent"
}


return module
