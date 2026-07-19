local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.applyMovementInterrupted(event : combatEventTypes.unitMovementInterruptedEvent, context)
	--[[local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	if unit:getAttacker():getVersioning():getMovementVersion() ~= event.data.movementVersion then 
		event.isValid = false
		event.shouldRender = false
		return
	end
	]]
	
end

function module.applyMovementResolved(event : eventType.unitMovementResolvedEvent, context)
	local unitsBC = context["UnitsBC"]

	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	if unit:getAttacker():getVersioning():getMovementVersion() ~= event.data.unitVersion then 
		event.isValid = false
		event.shouldRender = false
	end
end

function module.applyMovementStarted(event : eventType.unitMovementStartedEvent, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
		
	if unit:getAttacker():getVersioning():getMovementVersion() ~= event.data.unitVersion then 
		event.isValid = false 
		event.shouldRender = false
		return
	end
end

return module
