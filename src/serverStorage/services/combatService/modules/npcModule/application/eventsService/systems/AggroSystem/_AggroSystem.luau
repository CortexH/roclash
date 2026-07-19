local module = {}

module.applies = {
	["DamageAppliedEvent"] = require(script.Parent.ListenDamageAppliedEvent).handle,
	["UnitAggroStoppedEvent"] = require(script.Parent.ListenAggroStoppedEvent).handle,
	["UnitDiedEvent"] = require(script.Parent.ListenUnitDiedEvent).handle,
	["UnitSpawnedEvent"] = require(script.Parent.ListenUnitSpawnEvent).handle,
	["UnitAggroSearchEvent"] = require(script.Parent.ListenAggroSearch).handle,

	["UnitAggroCommand"] = require(script.Parent.ListenAggroCommand).handleEvent,
	["UnitAggroCommandSuccess"] = require(script.Parent.ListenAggroCommandResponse).handleSuccess,
	--["UnitAggroCommandFail"] = require(script.Parent.ListenAggroCommandResponse).handleFail,

	["UnitAggroIntent"] = require(script.Parent.AggroIntentSystem).handle
}

module.generates = {
	"Generate_UnitAggroStartedEvent",
	"Generate_UnitAggroStoppedEvent"
}

return module

