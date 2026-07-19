local module = {}

module.__index = module

export type aggro = typeof(module.new())

function module.new()
	local self = setmetatable({}, module)
	
	self.currentTargetId = nil
	self.aggroing = false
	
	return self
end

function module:setAggroTarget(targetId : string)
	if not targetId then self.aggroing = false else self.aggroing = true end
	self.currentTargetId = targetId
end

function module:removeUnitAggroTarget()
	self.currentTargetId = nil
	self.aggroing = false
end

function module:isUnitAggroing()
	return self.aggroing
end

function module:getAggroTargetId()
	return self.currentTargetId
end

return module
