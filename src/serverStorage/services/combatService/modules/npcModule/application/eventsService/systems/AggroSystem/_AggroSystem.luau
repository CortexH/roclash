local module = {}

module.applies = {
	["DamageAppliedEvent"] = require(script.Parent.ListenDamageAppliedEvent).handle,
	["UnitAggroStoppedEvent"] = require(script.Parent.ListenAggroStoppedEvent).handle,
	["UnitDiedEvent"] = require(script.Parent.ListenUnitDiedEvent).handle,
	["UnitSpawnedEvent"] = require(script.Parent.ListenUnitSpawnEvent).handle,
	["UnitAggroSearchEvent"] = require(script.Parent.ListenAggroSearch).handle,
	["MoveIntentRejected"] = require(script.Parent.ListenMovementIntentRejected).handle,

	["AggroIntent"] = require(script.Parent.AggroIntentSystem).handle
}

module.generates = {
	"Generate_UnitAggroStartedEvent",
	"Generate_UnitAggroStoppedEvent",
	"Generate_VerifyAggroReachedEvent"
}

return module

