local module = {}

--TODO: Alterar lugar do mapper.
--o mapper está no lugar errado, pois é mapper de entrada, portanto deverá estar em 'inbound'

local entityModule = require(game.ServerStorage.Server.constants.CombatServiceModulesConsts)
local unitDTO = require(game.ServerStorage.Server.services.combatService.modules.entityModule.application.DTO.UnitDTO)

function module.toStructureInbound(entity) : unitDTO.unitDTO
	local item : unitDTO.unitDTO = {
		["maxHealth"] = entity[2],
		["damage"] = entity[3],
		["attackSpeed"] = entity[4],
		["range"] = entity[5],
		["cell"] = getCell(entity),
		["facing"] = entity[7]
	}
	return item
end

function module.toNpcInbound(entity) : unitDTO.unitDTO
	local item : unitDTO.unitDTO = {
		["maxHealth"] = entity[1],
		["damage"] = entity[2],
		["attackSpeed"] = entity[3],
		["range"] = entity[4],
		["cell"] = getCellNpc(entity),
		["facing"] = entity[9]
	}
	return item
end

function module.toNotPlacedNpcInbound(data) : unitDTO.unitDTO

	local dto : unitDTO.unitDTO = {
		maxHealth = data["maxHealth"],
		damage = data["attackDamage"],
		attackSpeed = data["attackSpeed"],
		range = data["attackRange"]
	}
	
	return dto
end

function getCell(entity) : {x : number, y : number}
	return {x = entity[6][1], y = entity[6][2]}
end

function getCellNpc(entity) : {x : number, y : number}
	return {x = entity[8][1], y = entity[8][2]}

end

export type structureEntity = typeof(module.toInbound({}))


return module
