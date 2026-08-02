local module = {}

module.data = {}

function module.register(unitId)
	table.insert(module.data, unitId)
end

function module.remove(unitId)
	local index = table.find(module.data, unitId)
	if index then
		table.remove(module.data, index)
	end
end

function module.getAll()
	return table.clone(module.data)
end

function module.getRandom(seed)
	local random = Random.new(seed or 1)
	local randomIndex = random:NextInteger(1, #module.data)
	return module.data[randomIndex]
end

return module
