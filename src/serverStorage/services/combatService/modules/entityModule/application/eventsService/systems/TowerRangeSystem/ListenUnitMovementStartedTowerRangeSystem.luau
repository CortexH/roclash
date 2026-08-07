local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local towerDomainService = require(domain.domainService.TowerDomainService)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.handle(event : eventType.unitMovementStartedEvent, context)
	if event.isValid == false then return {} end	

	local unitsBC = context["UnitsBC"]
	
	local allInGameUnits = unitsBC:getAllActiveUnits()
	local walkingUnit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	local allAttackerUnits = {}

	for _, v : unitEntity.unitEntity in allInGameUnits do
		if not v:getAttacker() then continue end
		if walkingUnit:getParty() == v:getParty() then continue end
		
		table.insert(allAttackerUnits, v)
	end
	
	local intersectedUnits = towerDomainService.verifyNpcWalkingIntersection(
		walkingUnit,
		event.data.beginPosition,
		event.data.finalPosition,
		allAttackerUnits
	)
	
	local generatedEvents = {}
	
	for k, v in pairs(intersectedUnits) do
		local attacker : unitEntity.unitEntity = unitsBC:getActiveUnitById(k)
		
		if v.enterTime then
			table.insert(generatedEvents, generateEnteredRangeEvent(
				v.enterTime, attacker, walkingUnit
				))
		end
		
		if v.leaveTime then
			table.insert(generatedEvents, generateLeftRangeEvent(
				v.leaveTime, attacker, walkingUnit
				))
		end
	end
	
	return generatedEvents
end

function generateEnteredRangeEvent(delay, tower : unitEntity.unitEntity, target : unitEntity.unitEntity)
	local event : eventType.unitEnteredTowerRangeEvent = {
		delay = delay,
		eventType = "UnitEnteredTowerRangeEvent",
		type = "EVENT",
		data = {
			towerUnitId = tower:getId(),
			targetUnitId = target:getId(),
			towerUnitVersion = tower:getAttacker():getVersioning():getMovementVersion(),
			targetUnitVersion = target:getAttacker():getVersioning():getMovementVersion()
		},
		isValid = true
	}
	
	return event
end

function generateLeftRangeEvent(delay, tower : unitEntity.unitEntity, target : unitEntity.unitEntity)
	local event : eventType.unitLeftTowerRangeEvent = {
		delay = delay,
		eventType = "UnitLeftTowerRangeEvent",
		type = "EVENT",
		data = {
			towerUnitId = tower:getId(),
			targetUnitId = target:getId(),
			towerUnitVersion = tower:getAttacker():getVersioning():getMovementVersion(),
			targetUnitVersion = target:getAttacker():getVersioning():getMovementVersion()
		},
		isValid = true
	}
	
	return event
end

return module
