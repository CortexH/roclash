local module = {}

module.__index = module

function module.new(maxTargets)
	local self = setmetatable({}, module)
	
	self.possibleTargets = {}
	self.activeTargets = {}
	
	self.activeTargetsCount = 0
	
	self.maxTargets = maxTargets or 1
	
	return self
end

function module:getPossibleTargets()
	return self.possibleTargets
end

function module:getPossibleTargetsList()
	local list = {}
	for id, v in pairs(self.possibleTargets) do
		table.insert(list, id)
	end
	return list
end

function module:addPossibleTarget(unitId)
	self.possibleTargets[unitId] = true
end

function module:removePossibleTarget(unitId)
	self.possibleTargets[unitId] = nil
end

function module:addActiveTarget(unitId)
	if self.activeTargetsCount >= self.maxTargets then return end
	if self.activeTargets[unitId] then return end

	self.activeTargets[unitId] = true
	self.activeTargetsCount += 1
end

function module:getActiveTargets()
	return self.activeTargets
end

function module:getActiveTargetsList()
	local list = {}
	
	for i, v in pairs(self.activeTargets) do
		table.insert(list, i)
	end
	
	return list
end

function module:removeActiveTarget(unitId)
	if not self.activeTargets[unitId] then return end
	self.activeTargets[unitId] = nil
	self.activeTargetsCount -= 1
end

function module:getMaxActiveTargets()
	return self.maxTargets
end

function module:getActiveTargetSpace()
	return self.maxTargets - self.activeTargetsCount
end

function module:isActiveTarget(target)
	return self.activeTargets[target] == true
end

function module:wasActiveTarget(unitId)
	return self.activeTargets[unitId] == true
end

export type Targeting = typeof(module.new())

return module
