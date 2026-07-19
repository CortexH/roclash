local module = {}

module.__index = module

export type unitStructureDefinition = typeof(module.new("a", 1))

function module.new(
	id : string,
	structureType : number
)
	local self = setmetatable({}, module)
	
	self.definitionType = "STRUCTURE"
	self.unitId = id
	self.structureType = structureType	
	
	return self
end

function module:getId()
	return self.unitId
end

return module
