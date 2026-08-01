local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)


function module.apply(event : eventType.cooldownReadyEvent, context)
	if event.isValid == false then return end
	local unit : unitEntity.unitEntity = context.UnitsBC:getActiveUnitById(event.data.unitId)
    
    if unit:isDead() then
        event.isValid = false
        return
    end

    

end

return module
