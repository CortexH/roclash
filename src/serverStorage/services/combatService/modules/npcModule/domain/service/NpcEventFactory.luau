local module = {}

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

function module.createUnitAggroStartedEvent(delay, aggroingUnit, target)
	return {
		["delay"] = delay,
		["eventType"] = "UnitAggroStartedEvent",
		["type"] = "EVENT",
		["data"] = {
			["aggroingUnitId"] = aggroingUnit,
			["aggroedUnitId"] = target,
			--["aggroingUnitMovementVersion"] = string,
			--["aggroedUnitMovementVersion"] = string
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

function module.createMovementRequestEvent(delay, unitId, targetCell, targetUnit) : combatEventTypes.unitMovementRequestedEvent
	return {
		["eventType"] = "UnitMovementRequestedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["targetCell"] = targetCell,
			["targetUnit"] = targetUnit
		}
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

function module.createUnitIdleEvent()
	return {}
end

return module
