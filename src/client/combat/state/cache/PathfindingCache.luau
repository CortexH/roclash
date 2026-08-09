local module = {}

-- Cache dos paths de preview do sistema, indexado por unitId.
-- Cada entrada contém {start, goal, path, blockers} do último preview calculado.
module.data = {}

function module.register(unitId : string, pathData)
	module.data[unitId] = pathData
end

function module.get(unitId : string)
	return module.data[unitId]
end

function module.unregister(unitId : string)
	module.data[unitId] = nil
end

function module.getAll()
	return module.data
end

return module