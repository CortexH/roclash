local module = {}

module.__index = module

module.contextName = "ConstsBC"

function module.new()
	local self = setmetatable({}, module)
	
	self.seed = math.random(100000, 1000000)
	
	self.mapConsts = {
		mapId = nil,
		cellSize = nil
	}
	
	return self
end

return module
