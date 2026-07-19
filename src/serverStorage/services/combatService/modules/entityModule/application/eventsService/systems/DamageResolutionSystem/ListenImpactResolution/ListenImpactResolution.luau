local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

-- TODO: fazer os outros dispatchers
local dispatcher = {
	["POINT"] = require(script.Parent.PointTypeImpactHandler).handle,
	["RADIUS"] = require(script.Parent.RadiusTypeImpactHandler).handle,
	["LINE"] = function() return {} end,
	["CONE"] = function() return {} end
}

function module.handle(event : eventType.attackImpactEvent, context)
	if event.isValid == false then return {} end	

	local unitsBC = context["UnitsBC"]
	
	local sourceUnit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.sourceUnitId)
	local targetUnit : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.impactUnitId)
	
	local events = dispatcher[sourceUnit:getAttacker():getAttackerConfig()
		:getImpactShape()](sourceUnit, targetUnit, event.data.impactNumber, context, event.data.impactPosition)
	
	return events
end

return module
