local module = {}

module.applies = {
	["UnitDiedEvent"] = require(script.Parent.ApplyUnitDied).apply,
	["UnitSpawnedEvent"] = require(script.Parent.ApplyUnitSpawned).apply,
	["UnitEnteredTowerRangeEvent"] = require(script.Parent.ApplyUnitEnteredTowerRangeNpcTargeting).apply,
	["UnitLeftTowerRangeEvent"] = require(script.Parent.ApplyUnitLeftTowerRange).apply,
	["TargetAcquiredEvent"] = require(script.Parent.ApplyTargetAcquiredEvent).apply,
	["TargetLostEvent"] = require(script.Parent.ApplyTargetLostEvent).apply
}

return module
