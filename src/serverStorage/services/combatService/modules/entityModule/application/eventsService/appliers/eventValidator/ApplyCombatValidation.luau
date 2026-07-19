local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

--local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
--local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

--local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.applyCooldownReady(event : eventType.cooldownReadyEvent, context)
	local unit : unitEntity.unitEntity = context.UnitsBC:getActiveUnitById(event.data.unitId)
	if (not unit) or unit:isDead() then
		event.isValid = false
		return
	end
end

function module.applyAttackStarted(event : eventType.attackStartedEvent, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.attackerId)

	if not unit or unit:isDead() then
		event.isValid = false
		event.shouldRender = false
		return
	end
end

function module.applyAttackResolved(event : eventType.attackResolvedEvent, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.attackerId)

	if not unit or unit:isDead() then
		event.isValid = false
		return
	end
end

function module.applyUnitEnteredTowerRange(event : eventType.unitEnteredTowerRangeEvent, context)
	local unitsBC = context["UnitsBC"]

	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.targetUnitId)
	local tower : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.towerUnitId)

	if not unit or not tower then
		event.isValid = false
		return
	end

	if unit:isDead() then event.isValid = false return end
	if tower:isDead() then event.isValid = false return end

	if unit:getAttacker():getVersioning():getMovementVersion() ~= event.data.targetUnitVersion then
		event.isValid = false
		return 
	end
	if tower:getAttacker():getVersioning():getMovementVersion() ~= event.data.towerUnitVersion then
		event.isValid = false
		return 
	end
end

function module.applyUnitLeftTowerRange(event : eventType.unitLeftTowerRangeEvent, context)
	local unitsBC = context["UnitsBC"]

	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.targetUnitId)
	local tower : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.towerUnitId)

	if not unit or not tower then
		event.isValid = false
		return
	end

	if unit:isDead() then event.isValid = false return end
	if tower:isDead() then event.isValid = false return end

	if unit:getAttacker():getVersioning():getMovementVersion() ~= event.data.targetUnitVersion then event.isValid = false return end
	if tower:getAttacker():getVersioning():getMovementVersion() ~= event.data.towerUnitVersion then event.isValid = false return end	
end

return module
