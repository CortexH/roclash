local module = {}

module.__index = module

local secondTime = 30 -- 30 de attack speed equivale a 1 ataque por segundo. 60 são 2, e assim por diante

function module.new(attackSpeed: number)
	local self = setmetatable({}, module)
	
	self.attackSpeed = attackSpeed

	return self
end

function module:getValue()
	return self.attackSpeed
end

function module:getAttackCooldownTime()
	local attackSpeed = self:getValue()
	return secondTime / attackSpeed
end

function module:getTotalCooldown()
	return self.attackSpeed / secondTime
end

export type AttackSpeedVO = typeof(module.new(0))

return module
