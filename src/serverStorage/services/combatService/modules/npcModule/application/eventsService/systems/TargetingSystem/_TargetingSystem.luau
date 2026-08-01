local module = {}

module.applies = {
	["UnitStructureBlockingPathEvent"] = require(script.Parent.ListenPathBlockedEvent).handle,
	["UnitReachedAggroEvent"] = require(script.Parent.ListenUnitReachedAggroEvent).handle,
	["VerifyAggroReachedEvent"] = require(script.Parent.ListenVerifyAggroReachedEvent).handle,
	["UnitSpawnedEvent"] = require(script.Parent.ListenUnitSpawned).handle,
	["UnitDiedEvent"] = require(script.Parent.ListenUnitDied).handle,
	["UnitEnteredTowerRangeEvent"] = require(script.Parent.ListenUnitEnteredTowerRange).handle,
	["UnitLeftTowerRangeEvent"] = require(script.Parent.ListenUnitLeftTowerRange).handle,
}

module.generates = {
	"Generate_TargetAcquiredEvent",
	"Generate_TargetLostEvent"
}

return module
