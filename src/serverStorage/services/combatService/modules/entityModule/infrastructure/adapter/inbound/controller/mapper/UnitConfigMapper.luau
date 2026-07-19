local module = {}

export type structureDefinition = typeof(module.toStructureInbound({}))
export type npcDefinition = typeof(module.toNpcInbound({}))

--TODO verificar dados da definition
function module.toStructureInbound(entity : {}) : structureDefinition
	return {
		["structureType"] = entity[1],
	}
end

function module.toNpcInbound(entity : {}) : npcDefinition
	return {
		sword = entity[10],
		equipment = entity[11],
		aggroRange = entity[6],
		behavior = entity[7],
		damageType = entity[5],
		walkSpeed = entity[12]
	}
end

function module.toNotPlacedNpcInbound(entity)
	return {
		sword = entity["sword"],
		equipment = entity["equipment"],
		aggroRange = entity["aggroRange"],
		behavior = nil,
		damageType = entity["damageType"],
		walkSpeed = entity["walkSpeed"]
	}
end

return module
