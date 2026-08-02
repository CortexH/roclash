local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.handle(event : eventType.damageAppliedEvent, context)
	if event.isValid == false then return {} end

	local unitsBC = context["UnitsBC"]
	
	local target : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.targetId)
	local source = unitsBC:getActiveUnitById(event.data.sourceId)
	
	-- Invariante: a transição Alive -> Dead só pode ocorrer uma vez por unidade.
	-- A morte é aplicada imediatamente no applier de dano (justDied = true).
	-- Aqui geramos o UnitDiedEvent apenas na transição, e limpamos a flag para
	-- que danos subsequentes no mesmo frame não gerem novas mortes.
	if target:isDead() and target.justDied then
		target.justDied = false
		return {generateUnitDiedEvent(target, source)}
	end
	
	return {}
	
end

function generateUnitDiedEvent(unit : unitEntity.unitEntity, source : unitEntity.unitEntity)
	
	local event : eventType.unitDiedEvent = {
		delay = 0,
		eventType = "UnitDiedEvent",
		type = "EVENT",
		data = {
			targetId = unit:getId(),
			sourceId = source:getId()
		}
	}
	
	return event
end

return module
