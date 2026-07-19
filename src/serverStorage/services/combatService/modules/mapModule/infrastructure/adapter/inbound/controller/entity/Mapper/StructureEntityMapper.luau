local module = {}

local structureEntity = require(script.Parent.Parent.entity.StructureEntity)

function module.toInbound(entity : {}) : structureEntity.entity
	return {
		["maxLife"] = entity["maxHealth"],
		["facing"] = entity["currentFacing"],
		["uniqueId"] = entity["uniqueId"],
		["cell"] = {
			["x"] = entity["startCell"]["x"],
			["y"] = entity["startCell"]["y"]
		}
	}
	
end

return module
