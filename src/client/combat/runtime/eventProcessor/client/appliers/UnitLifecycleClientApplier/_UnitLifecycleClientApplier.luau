local module = {}

module.applies = {
	["UnitSpawn"] = require(script.Parent.UnitSpawnClientApplier).apply,
	["UnitDied"] = require(script.Parent.UnitDiedClientApplier).apply
}

return module
