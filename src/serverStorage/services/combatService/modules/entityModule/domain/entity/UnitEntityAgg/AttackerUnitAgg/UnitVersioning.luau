local module = {}

module.__index = module

export type unitVersioning = typeof(module.new())

function module.new()
	local self = setmetatable({}, module)
	
	self.movementVersion = 1
	self.attackVersion = 1
	self.aggroVersion = 1
	self.lifeVersion = 1

	return self
end

function module:incrementMovementVersion()
	self.movementVersion += 1
end

function module:incrementAttackVersion()
	self.attackVersion += 1
end

function module:incrementAggroVersion()
	self.aggroVersion += 1
end	

function module:incrementLifeVersion()
	self.lifeVersion += 1
end

function module:getMovementVersion()
	return self.movementVersion
end

function module:getAttackVersion()
	return self.attackVersion
end

function module:getAggroVersion()
	return self.aggroVersion
end

function module:getLifeVersion()
	return self.lifeVersion
end

return module
