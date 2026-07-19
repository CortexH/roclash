local module = {}

module.__index = module

module.contextName = "MapStateBC"


function module.new()
	local self = setmetatable({}, module)
	
	self.reservedCells = {}
	
	return self
end

return module
