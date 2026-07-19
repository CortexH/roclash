local module = {}

module.__index = module

module.contextName = "NpcsBC"

function module.new()
	local self = setmetatable({}, module)

	self.brains = {}
	
	return self
end

function module:addBrain(id, brain)
	self.brains[id] = brain
end

function module:getBrain(id)
	return self.brains[id]
end

function module:getAllBrainsList()
	local list = {}
	
	for _, brain in pairs(self.brains) do
		table.insert(list, brain)
	end
	
	return list
end

function module:getAllBrains()
	return self.brains
end

return module
