local module = {}

export type AttackerUnit = typeof(module.newForType())

local unitDamageVO = require(script.Parent.AttackerUnitAgg.UnitDamageVO)
local unitRangeVO = require(script.Parent.AttackerUnitAgg.UnitRangeVO)
local unitAttackSpeedVO = require(script.Parent.AttackerUnitAgg.UnitAttackSpeedVO)

local position = require(script.Parent.UnitPosition)

local attackerConfig = require(script.Parent.AttackerUnitAgg.AttackerConfig)
local unitTarget = require(script.Parent.AttackerUnitAgg.UnitTarget)
local unitAggro = require(script.Parent.AttackerUnitAgg.Aggro)

local versioning =  require(script.Parent.AttackerUnitAgg.UnitVersioning)

local state = require(script.Parent.AttackerUnitAgg.AttackerState)

module.__index = module

-- TODO: adicionar configuração 'max targets'
function module.new(
	damage : number,
	range: number,
	attackSpeed : number,
	config : attackerConfig.attackerConfig,
	seed : number
)

	local self = setmetatable({}, module)
	
	if(damage == 0 or range == 0 or attackSpeed == 0) then return nil end
	
	self.damage = unitDamageVO.new(damage)
	self.attackRange = unitRangeVO.new(range)
	self.attackSpeed = unitAttackSpeedVO.new(attackSpeed)
	self.config = config
	
	self.targeting = unitTarget.new(1, seed)
	self.aggro = unitAggro.new()
	self.version = versioning.new()
	self.state = state.new()
	
	return self
end

function module.newForType()
	local self = setmetatable({}, module)

	self.damage = unitDamageVO.new(15)
	self.attackRange = unitRangeVO.new(15)
	self.attackSpeed = unitAttackSpeedVO.new(15)
		
	self.lastAttackTime = nil
	
	self.config = nil
	
	self.targeting = unitTarget.new()
	self.aggro = unitAggro.new()
	self.version = versioning.new()
	self.state = state.new()
	
	return self
end

function module:canAttack(currentTime : number)
	return self:getRemainingCooldown(currentTime) <= 0
	and self:getState():getState() == "IDLE"
end

function module:getRemainingCooldown(ct)
    local lastAttackTime = self:getLastAttackTime()
    if not lastAttackTime then
        return 0
    end

    local cooldownTime = self:getAttackCooldownTime()
    if not cooldownTime then
        return 0
    end

    local remaining = (lastAttackTime + cooldownTime) - ct

    return math.max(0, remaining)
end

function module:getRange() : number
	return self.attackRange:getValue()
end

function module:getDamage()
	return self.damage:getValue()
end

function module:getAttackSpeed()
	return self.attackSpeed:getValue()
end

function module:getAttackCooldownTime()
	return self.attackSpeed:getAttackCooldownTime()
end

function module:getUnitTarget() : unitTarget.UnitTarget
	return self.targeting
end

function module:addTarget(focusedEntityId)
	self:getUnitTarget():addTargetCandidate(focusedEntityId)
	self:getUnitTarget():update()
end

function module:canTargetOneMore()
	return self:getUnitTarget():canTargetOneMore()
end

function module:getTargets()
	return self:getUnitTarget():getTargets()
end

function module:removeTarget(id)
	self:getUnitTarget():removeTargetOrCandidate(id)
	self:getUnitTarget():update()
end

function module:setLastAttackTime(attackTime)
	self.lastAttackTime = attackTime
end

function module:getLastAttackTime()
	return self.lastAttackTime
end

function module:getAttackerConfig() : attackerConfig.attackerConfig
	return self.config
end

function module:getVersioning() : versioning.unitVersioning
	return self.version
end

function module:getAggro() : unitAggro.aggro
	return self.aggro
end

function module:getState() : state.state
	return self.state
end

return module
