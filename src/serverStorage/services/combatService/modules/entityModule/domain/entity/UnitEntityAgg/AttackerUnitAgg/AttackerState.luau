local module = {}

module.__index = module

export type statesTypes = "IDLE" | "ATTACKING" | "WALKING"
export type state = typeof(module.new())

function module.new() : state
	local self = setmetatable({}, module)
	
	self.lastActionTime = 0
	self.completeTime = 0 -- define o tempo que a ação pode ser interrompida
	
	self.currentState = "IDLE"
	
	return self
end

function module:canChangeState(currentTime) : boolean
	if self.completeTime <= currentTime then return true end
	return false
end

function module:setAttacking(attackTime, completeTime)
	self.currentState = "ATTACKING"
	self.lastActionTime = attackTime
	self.completeTime = completeTime
end

function module:setWalking(currentTime)
	self.currentState = "WALKING"
	self.lastActionTime = currentTime
	self.completeTime = currentTime
end

function module:setIdle(currentTime)
	self.currentState = "IDLE"
	self.lastActionTime = currentTime
	self.completeTime = currentTime
end

function module:getLastActionTime()
	return self.lastActionTime
end

function module:getCompleteTime()
	return self.completeTime
end

function module:getState() : statesTypes
	return self.currentState
end

return module
