local module = {}

local contracts = require(game.ServerStorage.Server.services.combatService.API.frontEnd.Contracts)

function module.toFrontData(npc) : contracts.loadDataContract
	local data : contracts.loadDataContract = {}
	
	data.aggroRange = npc.aggroRange
	data.attackDamage = npc.attackDamage
	data.attackRange = npc.attackRange
	data.attackSpeed = npc.attackSpeed
	data.currentHealth = npc.currentHealth
	data.damageType = npc.damageType
	data.sword = npc.sword
	data.equipment = npc.equipment
	data.maxHealth = npc.maxHealth
	data.uniqueId = npc.uniqueId
	data.walkSpeed = npc.walkSpeed
	
	return data
	
end

return module
