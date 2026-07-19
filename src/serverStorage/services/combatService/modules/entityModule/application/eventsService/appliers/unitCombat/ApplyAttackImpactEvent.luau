local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.apply(event : eventType.attackImpactEvent, context)
	if event.isValid == false then return end
	event.shouldRender = true
end

return module
