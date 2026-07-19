local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.apply(event : combatEventTypes.unitMovementInterruptedEvent, context)
	if event.isValid == false then return {} end	

	local unitsBC = context["UnitsBC"]
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	
	unitsBC:unitChangedPosition(unit:getCurrentCell(), mapPort.getCellFromPosition(event.data.finalPos), event.data.unitId)
	
	unit:getPosition():setCurrentPosition(event.data.finalPos)
	unit:getPosition():clearActiveMovement()
	unit:setCurrentCell(mapPort.getCellFromPosition(event.data.finalPos))
	
	unit:getAttacker():getVersioning():incrementMovementVersion()
	unit:getAttacker():getState():setIdle(context["TimeBC"].currentTime)
end


return module

