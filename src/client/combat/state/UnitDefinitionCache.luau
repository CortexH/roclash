local unitDefinitionType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitDefinitionDataType)

local module = {}
module.data = {}

function module.register(unitId : string, definition : unitDefinitionType.unitDefinition)
	module.data[unitId] = definition
end

function module.get(unitId) : unitDefinitionType.unitDefinition
	return module.data[unitId]
end

function module.unregister(unitId)
	module.data[unitId] = nil
end

return module
