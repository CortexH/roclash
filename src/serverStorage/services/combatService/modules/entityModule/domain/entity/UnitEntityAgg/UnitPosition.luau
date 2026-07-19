local module = {}

local position = require(script.Parent.Parent.Parent.Parent.domain.valueObjects.Position)

local movement = require(script.Parent.Parent.Parent.Parent.domain.valueObjects.UnitMovement)

export type unitPosition = typeof(module.newWithAll())

module.__index = module

function module.new(startPosition : position.position)
	local self = setmetatable({}, module)
	
	self.startPosition = startPosition
	self.currentPosition = startPosition
	
	self.activeMovement = nil
	
	return self
end

function module.newWithAll(startPosition, currentPosition)
	local self = setmetatable({}, module)
	
	self.startPosition = startPosition
	self.currentPosition = currentPosition
	
	self.activeMovement = movement.new()
	
	return self
end

function module.newEmpty()
	local self = setmetatable({}, module)
	
	self.startPosition = nil
	self.currentPosition = nil
	
	return self
end

function module:getCurrentPosition(currentTime):position.position
	
	if not currentTime then return self.currentPosition end
	local movement : movement.unitMovement = self.activeMovement
	
	if not movement then return self.currentPosition end
	
	if movement:isExpired(currentTime) then return self.currentPosition end	
	
	return movement:getPositionAtTime(currentTime)
end

function module:setCurrentPosition(other)
	self.currentPosition = other
end

function module:getStartPosition()
	return self.startPosition
end

function module:getActiveMovement() : movement.unitMovement
	return self.activeMovement
end

function module:setActiveMovement(movement)
	self.activeMovement = movement
end

function module:clearActiveMovement()
	self.activeMovement = nil
end

return module
