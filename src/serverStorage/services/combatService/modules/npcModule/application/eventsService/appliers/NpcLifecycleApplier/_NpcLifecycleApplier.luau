local module = {}

module.applies = {
	["UnitDiedEvent"] = require(script.Parent.ApplyUnitDiedLifecycle).apply,
	["UnitSpawnedEvent"] = require(script.Parent.ApplyUnitSpawnedLifecycle).apply
}

return module
