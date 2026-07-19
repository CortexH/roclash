local module = {}

module.__index = module
local position = require(script.Parent.Position)

export type unitMovement = typeof(module.new())

function module.new(
	from : position.position,
	to : position.position,
	duration : number,
	startTime
)
	local self = setmetatable({}, module)
	
	self.distance = from:distanceTo(to)
	self.direction = from:directionTo(to)
	self.speed = self.distance / duration
	
	self.startTime = startTime
	self.arrivalTime = startTime + duration
	
	self.from = from
	self.to = to
	self.duration = duration
	
	return self
end

function module:getPositionAtTime(time : number)

	if time <= self.startTime then
		return self.from
	end

	if time >= self.arrivalTime then
		return self.to
	end

	local deltaTime = time - self.startTime
	local displacement = self.direction:mul(self.speed * deltaTime)

	return self.from:add(displacement)
end

function module:isExpired(time : number)
	return time > self.arrivalTime
end

return module
