local module = {}

module.applies = {
	["UnitAggroSearchEvent"] = require(script.Parent.ApplyAggroSearch).apply,
	["UnitSpawnedEvent"] = require(script.Parent.ApplyUnitSpawnEvent).apply,
	["UnitAggroStartedEvent"] = require(script.Parent.ApplyAggroStarted).apply,
	["UnitAggroStoppedEvent"] = require(script.Parent.ApplyAggroStopped).apply
}

return module
