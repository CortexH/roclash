local module = {}

module.__index = module

module.contextName = "BattleStateBC"

export type status = "AWAITING_START" | "RUNNING" | "ENDED"

function module.new()
	local self = setmetatable({}, module)
	
	self.winner = nil
	self.status = "AWAITING_START"
	
	return self
end

function module:getStatus() : status
	return self.status
end

function module:setStatus(status : status)
	if status ~= "AWAITING_START" and status ~= "RUNNING" and status ~= "ENDED" then return end
	self.status = status
end

return module
