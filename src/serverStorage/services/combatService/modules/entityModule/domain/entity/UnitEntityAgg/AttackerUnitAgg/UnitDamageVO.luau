local module = {}

module.__index = module

function module.new(
	damage : number
)
	local self = setmetatable({}, module)
	
	self.damage = damage
	
	return self
end

function module:getValue()
	return self.damage
end

export type DamageVO = typeof(module.new(0,0,0))

return module
