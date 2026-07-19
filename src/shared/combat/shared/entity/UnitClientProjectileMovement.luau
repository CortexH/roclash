local module = {}

module.__index = module

local functions = require(game.ReplicatedStorage.Shared.combat.shared.functions.ProjectileFunctions)
export type projectileMovement = typeof(module.new())

function module.new(
	projectileId : string,
	movementId : number,
	startTime : number,
	duration : number,
	startPos : Vector3,
	endPos : Vector3
)
	
	local self = setmetatable({}, module)
	
	self.projectileId = projectileId
	
	self.startTime = startTime
	self.duration = duration
	self.startPos = startPos
	self.endPos = endPos
	
	self.movementFunction = functions.get(movementId)
		
	assert(self.movementFunction, "Projectile movement function not found for typeId: " .. tostring(movementId))

	return self
end

function module:getPosition(currentTime : number)
	return self.movementFunction(currentTime, self)
end

function module:isFinished(currentTime)
	return (currentTime - self.startTime) >= self.duration
end

return module
