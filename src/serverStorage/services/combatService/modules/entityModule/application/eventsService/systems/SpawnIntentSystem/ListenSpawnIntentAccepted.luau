local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local unitEntity = require(domain.entity.UnitEntity)

-- Transforma um SpawnIntent aceito em UnitSpawnedEvent.
function module.handle(event, context)
	local unitsBC = context["UnitsBC"]
	local unit : unitEntity.unitEntity = unitsBC:getReservedUnitById(event.data.entityId)
	if not unit then return {} end

	local unitType = unit.config:getUnitType()
	local structureType = unit.config.structureType

	return {{
		eventType = "UnitSpawnedEvent",
		delay = 0,
		data = {
			entityId = event.data.entityId,
			position = event.data.position,
			behavior = event.data.behavior,
			rotation = 0,
			reason = "SUMMON",
			type = {
				unitType = unitType,
				structureTypeId = structureType
			}
		}
	}}
end

return module
