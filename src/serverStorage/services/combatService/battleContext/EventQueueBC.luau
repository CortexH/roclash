local module = {}

module.__index = module

module.contextName = "EventQueueBC"

function module.new()
	local self = setmetatable({}, module)
	
	self.events = {}
	self.consumedEvents = {}
	
	return self
end

return module
