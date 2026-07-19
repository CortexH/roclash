local module = {}

module.__index = module

export type aggroCandidate = {
	lastSeen : number,
	lastScore : number
}

function module.new()
	local self = setmetatable({}, module)
	
	self.aggro = nil
	self.candidates = {}
	
	return self
end

function module:getCurrentAggro()
	return self.aggro
end

function module:setAggro(unitId)
	self.aggro = unitId
end

function module:isAggroing()
	return self.aggro ~= nil
end

function module:getCandidates() : {[string] : aggroCandidate}
	return self.candidates
end

function module:addCandidate(unitId, time)
	self.candidates[unitId] = {
		lastSeen = time,
		lastScore = 0,
	}
end

function module:removeCandidate(unitId)
	self.candidates[unitId] = nil
end

function module:updateCandidateScore(unitId, score)
	if self.candidates[unitId] then
		self.candidates[unitId].lastScore = score
	end
end

function module:clearCandidates()
	self.candidates = {}
end

export type Aggro = typeof(module.new())

return module
