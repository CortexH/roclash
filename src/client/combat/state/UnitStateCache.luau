local module = {}

local stateType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitStateDataType)

module.data = {}

function module.register(unitId, unit)
	module.data[unitId] = unit
end

function module.get(unitId) : stateType.unitState
	return module.data[unitId]
end

function module.unregister(unitId)
	module.data[unitId] = nil
end

return module
