local module = {}

module.applies = {
	["UnitSpawnedEvent"] = require(script.parent.ApplyUnitSpawnedEventModule).apply,
	["UnitDiedEvent"] = require(script.parent.ApplyUnitDiedEventModule).apply
}

return module
