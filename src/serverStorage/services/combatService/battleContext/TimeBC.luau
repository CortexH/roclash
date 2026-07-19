local module = {}

module.__index = module

module.contextName = "TimeBC"

function module.new()
	local self = setmetatable({}, module)
	
	self.currentTime = nil
	self.startedAt = nil
	self.finishedAt = nil
	
	return self
end

return module
