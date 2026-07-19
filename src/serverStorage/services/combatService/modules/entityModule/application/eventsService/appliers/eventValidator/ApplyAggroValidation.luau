local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local movementService = require(domain.domainService.MovementDomainService)

local eventFactory = require(game.ServerStorage.Server.services.combatService.shared.services.EventFactory)

local mapPort = require(domain.ports.gateways.MapGatewayPort)


function module.applyUnitReachedAggroEvent(event, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.unitId)
	

	if not unit or unit:isDead() or unit:getAttacker():getVersioning():getAggroVersion() ~= event.data.aggroVersion then 
		event.isValid = false
		event.shouldRender = false
		return
	end
end

function module.applyAggroStoppedEvent(event, context)
	local unitsBC = context["UnitsBC"]
	
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.aggroingUnitId)
	
	if not unit or unit:isDead() then
		event.isValid = false
		event.shouldRender = false
		return
	end
	
	unit:getAttacker():getVersioning():incrementAggroVersion()
end

function module.applyAggroSearchEvent(event, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.aggroingUnitId)
	
	if not unit or unit:isDead() then
		event.isValid = false
		event.shouldRender = false
		return
	end
	
end

return module
