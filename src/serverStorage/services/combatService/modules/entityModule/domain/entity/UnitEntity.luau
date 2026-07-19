local unitEntity = {}

local valueObj = script.Parent.Parent.valueObjects

local attackerUnit = require(script.Parent.UnitEntityAgg.AttackerUnit)
local unitPosition = require(script.Parent.UnitEntityAgg.UnitPosition)
local position = require(valueObj.Position)
local unitConfig = require(script.Parent.UnitEntityAgg.UnitConfig)

local unitMovement = require(valueObj.UnitMovement)
local attackedBy = require(script.Parent.UnitEntityAgg.AttackedBy)

export type unitEntity = typeof(unitEntity.new())

unitEntity.__index = unitEntity

function unitEntity.new(
	uniqueId : string,
	maxHealth : number,
	startCell : {x : number, y : number},
	startFacing : number,
	attacker : attackerUnit.AttackerUnit,
	party : string,
	startPosition : position.position,
	config,
	unitOwner : string
)
	
	local self = setmetatable({}, unitEntity)
	
	self.uniqueId = uniqueId
	
	self.maxHealth = maxHealth
	self.currentHealth = maxHealth
	
	self.startCell = startCell
	self.currentCell = startCell
	
	self.startFacing = startFacing
	self.currentFacing = startFacing
	
	self.attackerUnit = attacker
	
	self.party = party
	
	self.placed = true
	
	self.position = unitPosition.new(startPosition)
	self.attackedBy = attackedBy.new()
	
	self.config = config
	self.owner = unitOwner
	
	self.version = 1
		
	self.alive = true
	
	return self
end

function unitEntity.newNotPlaced(
	uniqueId : string,
	maxHealth : number,
	attacker : attackerUnit.AttackerUnit,
	party : string,
	config,
	unitOwner : string
)
	local self = setmetatable({}, unitEntity)
	
	self.uniqueId = uniqueId
	
	self.maxHealth = maxHealth
	self.currentHealth = maxHealth
	self.attackerUnit = attacker
	
	self.party = party
	self.placed = false
	
	self.position = unitPosition.newEmpty()
	
	self.config = config
	self.owner = unitOwner
	
	self.version = 1
	
	self.alive = true
		
	return self
end

function unitEntity:changePosition(newCell)
	self.currentCell = newCell
end

function unitEntity:place(cell, facing, entityPos : position.position, behavior) : (boolean, string)
	
	local canPlace, canPlaceMsg = self:canPlace()
	
	if not canPlace then
		return false, canPlaceMsg
	end
	
	local behaviorSuc, behaviorMessage = self.config:setBehavior(behavior)
	
	if not behaviorSuc then
		return false, behaviorMessage
	end
	
	self.currentCell = cell
	self.startCell = cell
	
	self.startFacing = facing
	self.currentFacing = facing
	
	self.position = unitPosition.new(entityPos)
	
	self.placed = true
	self.attackedBy = attackedBy.new()

	return true
end

function unitEntity:canPlace() : (boolean, string)
	
	if self.placed then
		return false, "Unit já está placed"
	end
	
	return true
end

function unitEntity:isPlaced()
	return self.placed
end

function unitEntity:isInRange(other : position.position)
	if not self.placed then return false end

	local range :number = self:getAttacker():getRange()
	local thisPosition : position.position = self:getPosition():getCurrentPosition()
	
	return thisPosition:distanceTo(thisPosition) <= range
end

function unitEntity:isInAggroRange(other : position.position)
	if not self.placed then return false end
	if not self.config:getAggroRange() then return false end
	
	local thisAggroRange = self.config:getAggroRange()
	local thisPosition : position.position = self:getPosition():getCurrentPosition()
	
	return thisPosition:distanceTo(other) <= thisAggroRange
end

function unitEntity:getParty()
	return self.party
end

function unitEntity:getId()
	return self.uniqueId
end

function unitEntity:getAttacker() : attackerUnit.AttackerUnit
	return self.attackerUnit
end

function unitEntity:isAttacker() : boolean
	return self.attackerUnit ~= nil
end

function unitEntity:getNpcConfig() : unitConfig.npcConfig
	return self.config
end

function unitEntity:getStructureConfig() : unitConfig.structureConfig
	return self.config
end

function unitEntity:getPosition() : unitPosition.unitPosition
	return self.position
end

function unitEntity:getCurrentCell() : {x : number, y : number}
	return self.currentCell
end

function unitEntity:setCurrentCell(cell)
	self.currentCell = cell
end

function unitEntity:verifyPlacementInBlockType(blockType)
	return 
		not (blockType == "ONLY_FOR_NPC" or
		blockType == "ENTIRE_CELL" or
		blockType == "ONLY_CENTER")
end

function unitEntity:incrementVersion()
	self.version += 1
end

function unitEntity:getVersion()
	return self.version
end

function unitEntity:applyDamage(quantity)
	self.currentHealth -= quantity
end

function unitEntity:getHealth()
	return self.currentHealth
end

function unitEntity:getMaxHealth()
	return self.maxHealth
end

function unitEntity:isLowHealth()
	return self.currentHealth <= self.maxHealth * 0.25
end

function unitEntity:kill()
	self.alive = false
end

function unitEntity:isDead()
	return not self.alive
end

function unitEntity:validateOwner(owner)
	return self.owner == tostring(owner)
end

function unitEntity:getAttackedBy() : attackedBy.attackedBy
	return self.attackedBy
end

return unitEntity
