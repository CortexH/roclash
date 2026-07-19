local module = {}

local movement = require(script.Parent.ApplyMovementValidation)
local combat = require(script.Parent.ApplyCombatValidation)
local aggro = require(script.Parent.ApplyAggroValidation)

module.applies = {
	["UnitMovementStartedEvent"] = movement.applyMovementStarted,
	["UnitMovementResolvedEvent"] = movement.applyMovementResolved,
	["UnitMovementInterruptedEvent"] = movement.applyMovementInterrupted,
	
	["CooldownReadyEvent"] = combat.applyCooldownReady,
	["AttackStartedEvent"] = combat.applyAttackStarted,
	["AttackResolvedEvent"] = combat.applyAttackResolved,
	["UnitEnteredTowerRangeEvent"] = combat.applyUnitEnteredTowerRange,
	["UnitLeftTowerRangeEvent"] = combat.applyUnitLeftTowerRange,
	
	["UnitReachedAggroEvent"] = aggro.applyUnitReachedAggroEvent,
	["UnitAggroStoppedEvent"] = aggro.applyAggroStoppedEvent
}

return module
