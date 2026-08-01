local module = {}

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

function module.createUnitAggroStartedEvent(delay, aggroingUnit, target, aggroingUnitMovementVersion, aggroedUnitMovementVersion)
	return {
		["delay"] = delay,
		["eventType"] = "UnitAggroStartedEvent",
		["type"] = "EVENT",
		["data"] = {
			["aggroingUnitId"] = aggroingUnit,
			["aggroedUnitId"] = target,
			["aggroingUnitMovementVersion"] = aggroingUnitMovementVersion or "",
			["aggroedUnitMovementVersion"] = aggroedUnitMovementVersion or ""
		},
		["isValid"] = true
	}
end

function module.createUnitAggroStoppedEvent(delay, unit, target)
	return {
		["delay"] = delay,
		["eventType"] = "UnitAggroStoppedEvent",
		["type"] = "EVENT",
		["data"] = {
			["aggroingUnitId"] = unit,
			["aggroedUnitId"] = target,
		},
		["isValid"] = true
	}
end

function module.targetAcquired(delay : number?, unitId : string, targetId : string)
	return {
		eventType = "TargetAcquiredEvent",
		delay = delay or 0,
		type = "EVENT",
		data = {
			unitId = unitId,
			targetId = targetId
		}
	}
end

function module.targetLost(delay : number?, unitId : string, targetId : string)
	return {
		eventType = "TargetLostEvent",
		delay = delay or 0,
		type = "EVENT",
		data = {
			unitId = unitId,
			targetId = targetId
		}
	}
end

function module.createUnitAggroSearchEvent(delay, aggroingUnitId)
	return {
		["eventType"] = "UnitAggroSearchEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["aggroingUnitId"] = aggroingUnitId,
		},
		["isValid"] = true
	}
end

function module.createUnitMovementPlanningEvent(delay, unitId, firstCell, path, reachable)
	return {
		["eventType"] = "UnitMovementPlanningEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["startCell"] = firstCell,
			["unitId"] = unitId,
			["path"] = path,
			["reachable"] = reachable
		}
	}
end

function module.createMovementIntent(delay, unitId, targetCell, targetUnit, reason)
	return {
		["eventType"] = "MovementIntent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["targetCell"] = targetCell,
			["targetUnit"] = targetUnit,
			["reason"] = reason
		},
		["isValid"] = true
	}
end

function module.createMovementIntentAccepted(delay, unitId, targetCell, targetUnit, reason)
	return {
		["eventType"] = "MovementIntentAccepted",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["targetCell"] = targetCell,
			["targetUnit"] = targetUnit,
			["reason"] = reason
		},
		["isValid"] = true
	}
end

function module.createMovementIntentRejected(delay, unitId, targetCell, targetUnit, reason)
	return {
		["eventType"] = "MovementIntentRejected",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["targetCell"] = targetCell,
			["targetUnit"] = targetUnit,
			["reason"] = reason
		},
		["isValid"] = true
	}
end

function module.createVerifyAggroReachedEvent(delay, unitId, movementVersion)
	return {
		["eventType"] = "VerifyAggroReachedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["movementVersion"] = movementVersion
		},
		["isValid"] = true
	}
end

function module.createUnitStructureBlockingPathEvent(delay, blockerId)
	return {
		["eventType"] = "UnitStructureBlockingPathEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["blockerUnitId"] = blockerId
		},
		["isValid"] = true
	}	
end

function module.createMovementStoppedEvent(delay, unit, movementVersion)
	
end

function module.createAttackStartedEvent(delay, unitId, targetId)
	return {
		["eventType"] = "AttackStartedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["attackerId"] = unitId,
			["targetId"] = targetId
		},
		["isValid"] = true
	}	
end

function module.createAttackIntentFailed(sourceId, targetId, reason, originType, playerId)
	return {
		["eventType"] = "AttackIntentFailed",
		["delay"] = 0,
		["type"] = "EVENT",
		["data"] = {
			["source"] = sourceId,
			["target"] = {
				["targetType"] = "UNIT",
				["id"] = targetId,
				["position"] = {x = 0, y = 0}
			},
			["origin"] = {
				["type"] = originType or "SYSTEM",
				["playerId"] = playerId or nil
			},
			["reason"] = reason
		},
		["isValid"] = true
	}
end

function module.createAttackIntentAccepted(source, target)
	return {
		["eventType"] = "AttackIntentAccepted",
		["delay"] = 0,
		["type"] = "EVENT",
		["data"] = {
			["source"] = source,
			["target"] = target
		}
	}
end

function module.createUnitIdleEvent()
	return {}
end

return module

