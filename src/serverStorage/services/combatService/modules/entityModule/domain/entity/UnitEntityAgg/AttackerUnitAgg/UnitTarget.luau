local module = {}
module.__index = module

export type UnitTarget = typeof(module.new(1))

function module.new(maxTargets : number, seed)
	local self = setmetatable({}, module)

	self.maxTargets = maxTargets

	self.targetsList = {}
	self.targetsSet = {}

	self.candidatesList = {}
	self.candidatesSet = {}
	
	self.randomSeed = seed
	
	return self
end

local function removeFromList(list, value)
	for i = 1, #list do
		if list[i] == value then
			table.remove(list, i)
			return
		end
	end
end

function module:addTargetCandidate(unitId : string)

	if self.targetsSet[unitId] or self.candidatesSet[unitId] then
		return
	end

	if #self.targetsList < self.maxTargets then
		table.insert(self.targetsList, unitId)
		self.targetsSet[unitId] = true
	else
		table.insert(self.candidatesList, unitId)
		self.candidatesSet[unitId] = true
	end
end

function module:removeTargetCandidate(unitId : string)

	if not self.candidatesSet[unitId] then
		return
	end
	
	self.candidatesSet[unitId] = nil
	removeFromList(self.candidatesList, unitId)
end

function module:removeTarget(unitId : string)

	if not self.targetsSet[unitId] then
		return
	end

	self.targetsSet[unitId] = nil
	removeFromList(self.targetsList, unitId)

	if #self.candidatesList > 0 then
		local promoted = table.remove(self.candidatesList, 1)

		self.candidatesSet[promoted] = nil

		table.insert(self.targetsList, promoted)
		self.targetsSet[promoted] = true
	end
end

function module:getTargets()
	return table.clone(self.targetsList)
end

function module:removeTargetOrCandidate(id)

	if #self.targetsList > 0 then
		self:removeTarget(id)
	end
	if #self.candidatesList > 0 then
		self:removeTargetCandidate(id)
	end
end

function module:update()

	while #self.targetsList < self.maxTargets and #self.candidatesList > 0 do
		local random = Random.new(self.randomSeed)
		local promoted = table.remove(self.candidatesList, random:NextInteger(1, #self.candidatesList))

		self.candidatesSet[promoted] = nil

		table.insert(self.targetsList, promoted)
		self.targetsSet[promoted] = true
	end

end

function module:canTargetOneMore()
	return #self.targetsList <= self.maxTargets and #self.candidatesList < 1
end

return module