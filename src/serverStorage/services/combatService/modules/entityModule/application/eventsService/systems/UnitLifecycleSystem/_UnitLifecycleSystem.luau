local module = {}

module.applies = {
	["BeginGameEvent"] = require(script.Parent.ListenGameBegin).handle
}

module.generates = {
	"Generate_UnitSpawnedEvent"
}


return module
