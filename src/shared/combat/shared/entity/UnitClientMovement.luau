local module = {}
module.__index = module

local functions = require(game.ReplicatedStorage.Shared.combat.shared.functions.MovementFunctions)

export type unitMovement = typeof(module.new())

function module.new(
	unitId,
	typeId : number,
	startTime : number,
	duration : number,
	startPos : Vector3,
	endPos : Vector3
)
	local self = setmetatable({}, module)
	
	self.unitId = unitId
	
	self.typeId = typeId
	self.startTime = startTime
	self.duration = duration
	self.startPos = startPos
	self.endPos = endPos
	
	self.movementFunction = functions.get(typeId)
	
	assert(self.movementFunction, "Movement function not found for typeId: " .. tostring(typeId))
		
	return self
end

function module:getPosition(currentTime : number)
	return self.movementFunction(currentTime, self)
end

function module:isFinished(currentTime)
	return (currentTime - self.startTime) >= self.duration
end

return module