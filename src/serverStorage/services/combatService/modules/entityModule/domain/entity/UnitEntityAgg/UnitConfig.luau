local module = {}

export type npcConfig = typeof(module.newNpcConfig())
export type structureConfig = typeof(module.newStructureConfig())

export type structureBlockCellType = "ENTIRE_CELL" | "BORDER" | "ONLY_CENTER" | "ONLY_FOR_NPC"

module.__index = module

function module.newNpcConfig(
	equipment : number,
	sword : number,
	behavior : string,
	aggroRange : number,
	damageType : number,
	walkSpeed : number
) : npcConfig
	local self = setmetatable({}, module)
	
	self.unitType = "NPC"

	self.equipment = equipment
	self.sword = sword

	self.behavior = behavior
	self.aggroRange = aggroRange
	self.damageType = damageType

	self.walkSpeed = walkSpeed
	
	self.blockCellType = "ONLY_FOR_NPC"
		
	return self
end

function module.newStructureConfig(
	structureType : number,
	blockCellType : structureBlockCellType
) : structureConfig
	local self = setmetatable({}, module)
	
	self.unitType = "STRUCTURE"
	self.structureType = structureType
	
	self.blockCellType = blockCellType
		
	return self
end

function module:getStructureType()
	return self.structureType
end

function module:setBehavior(behavior) : (boolean, string)
	if self.unitType ~= "NPC" then return true end
	if not behavior then return false, "Behavior não pode ser nulo" end
	if(behavior ~= "AGGRESSIVE" and behavior ~= "DEFENSIVE" and behavior ~= "PEACEFUL") then
		return false, "'Behavior' deve ser 'AGGRESSIVE', 'DEFENSIVE' ou 'PEACEFUL'"
	end
	self.behavior = behavior
	return true
end

function module:getBehavior()
	return self.behavior
end

function module:getUnitType()
	return self.unitType
end

function module:getAggroRange() : number
	return self.aggroRange	
end

function module:getBlockCellType() : structureBlockCellType
	return self.blockCellType
end

function module:getWalkSpeed()
	return self.walkSpeed
end

function module:getWeaponType()
	return self.sword
end

function module:getEquipmentType()
	return self.equipment
end

return module
