local module = {}

module.__index = module

export type unitNpcDefinition = typeof(module.new())

function module.new(
	id : string,
	equipment : number,
	sword : number,
	behavior : string,
	aggroRange : number,
	damageType : number,
	walkSpeed : number
)
	
	local self = setmetatable({}, module)
	
	self.definitionType = "NPC"
	
	self.unitId = id
	
	self.equipment = equipment
	self.sword = sword
	
	self.behavior = behavior
	self.aggroRange = aggroRange
	self.damageType = damageType
	
	self.walkSpeed = walkSpeed
	
	return self
	
end

function module:getId()
	return self.unitId
end

function module:setBehavior(behavior) : boolean
	if not behavior then return false end
	if(behavior ~= "AGGRESSIVE" and behavior ~= "DEFENSIVE" and behavior ~= "PEACEFUL") then return false end
	self.behavior = behavior
	return true
end

return module
