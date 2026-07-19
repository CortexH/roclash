local module = {}

function module.createMovementStartedEvent(
	delay, unitId, beginPos, finalPos, movementVersion,
	walkSpeed, movementTime
)
	return {
		["eventType"] = "UnitMovementStartedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["beginPosition"] = beginPos,
			["finalPosition"] = finalPos,
			["unitId"] = unitId,
			["unitVersion"] = movementVersion,
			["walkSpeed"] = walkSpeed,
			["movementTime"] = movementTime
		}
	}
	
end

function module.createMovementResolvedEvent(
	delay, unitId, pos, movementVersion
)
	return {
		["eventType"] = "UnitMovementResolvedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["position"] = pos,
			["unitId"] = unitId,
			["unitVersion"] = movementVersion
		}
	}
end

function module.createMovementStoppedEvent(delay, unitId, beginPos, finalPos)
	return {
		["eventType"] = "UnitMovementResolvedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["movementBeginPosition"] = beginPos,
			["movementFinalPosition"] = finalPos
		},
		["isValid"] = true
	}
end

function module.createUnitIdleEvent(delay, unitId)
	return {
		["eventType"] = "UnitIdleEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId
		},
		["isValid"] = true
	}
end

function module.createMovementInterruptedEvent(
	delay, unitId, version, finalPos
)
	return {
		["eventType"] = "UnitMovementInterruptedEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["unitId"] = unitId,
			["finalPos"] = finalPos
		},
		["isValid"] = true
	}
end

function module.createUnitMovementIntentEvent(delay, unitId, firstCell, path, reachable)
	return {
		["eventType"] = "UnitMovementIntentEvent",
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

function module.createStructureBlockingPathEvent(delay, blockedUnitId, blockerUnitId)
	return {
		["eventType"] = "UnitStructureBlockingPathEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["blockerId"] = blockerUnitId,
			["unitId"] = blockedUnitId
		},
		["isValid"] = true
	}
end

function module.createUnitReachedAggroEvent(delay, unitId, unitVersion)
	return {
		["eventType"] = "UnitReachedAggroEvent",
		["delay"] = delay,
		["type"] = "EVENT",
		["data"] = {
			["aggroVersion"] = unitVersion,
			["unitId"] = unitId
		},
		["isValid"] = true
	}
end


return module
