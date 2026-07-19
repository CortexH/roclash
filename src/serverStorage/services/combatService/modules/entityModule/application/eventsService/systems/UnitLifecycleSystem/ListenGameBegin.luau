local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

function module.handle(event, context)
	local units = context["SnapshotBC"]["snapshotUnits"]
	
	print(units)

	local created = {}
		
	for i, v in pairs(units) do
		local unit = context["UnitsBC"]:getUnit(i)
		table.insert(created, createEvent(i, v.cell, v.orientation, unit))
	end
	
	return created
end

function createEvent(id, position, rot, unit)

	local unitType = unit.config:getUnitType()
	local structureType = unit.config.structureType

	return {
		eventType = "UnitSpawnedEvent",
		delay = 0,
		data = {
			["entityId"] = id,
			["position"] = position,
			["rotation"] = rot,
			["reason"] = "INITIAL",
			["type"] = {
				["unitType"] = unitType,
				["structureTypeId"] = structureType
			}
		}
	}
end

return module
