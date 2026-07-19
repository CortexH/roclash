local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.handle(event : eventType.unitSpawnedEvent, context)
	if event.isValid == false then return {} end
	
	local unitsBC = context["UnitsBC"]
	
	local allInGameUnits = unitsBC:getAllActiveUnits()
	local spawnedUnit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.entityId)
	
	local events = {}

	for _, attacker : unitEntity.unitEntity in allInGameUnits do
		if not attacker:getAttacker() then continue end
		if spawnedUnit:getParty() == attacker:getParty() then continue end
		if attacker:isDead() then continue end
		if spawnedUnit:isDead() then continue end
		
		local distance = spawnedUnit:getPosition():getCurrentPosition()
			:distanceTo(attacker:getPosition():getCurrentPosition())
		
		local attackerRange = attacker:getAttacker():getRange()
			
		if distance > attacker:getAttacker():getRange() then continue end
		
		table.insert(events, generateEnteredRangeEvent(
			0, attacker, spawnedUnit
			))
	end
	
	return events
end

function generateEnteredRangeEvent(delay, tower : unitEntity.unitEntity, target : unitEntity.unitEntity)
	local event : eventType.unitEnteredTowerRangeEvent = {
		delay = delay,
		eventType = "UnitEnteredTowerRangeEvent",
		type = "EVENT",
		data = {
			towerUnitId = tower:getId(),
			targetUnitId = target:getId(),
			towerUnitVersion = tower:getVersion(),
			targetUnitVersion = target:getVersion()
		},
		isValid = true
	}

	return event
end

return module
