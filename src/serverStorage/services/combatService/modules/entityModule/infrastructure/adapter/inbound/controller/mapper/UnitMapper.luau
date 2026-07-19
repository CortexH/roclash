local module = {}

local dto = require(script.Parent.Parent.dto.UnitOutboundDTO)
local npcDefinition = require(script.Parent.Parent.Parent.Parent.Parent.Parent.domain.entity.UnitNpcDefinition)
local unitEntity = require(script.Parent.Parent.Parent.Parent.Parent.Parent.domain.entity.UnitEntity)


function module.toNpcOutbound(unit : unitEntity.unitEntity)
		
	local data : dto.npcOutboundDTO = {
		["uniqueId"] = unit.uniqueId,
		["attackRange"] = unit.attackerUnit.attackRange.range,
		["attackSpeed"] = unit.attackerUnit.attackSpeed.attackSpeed,
		["attackDamage"] = unit.attackerUnit.damage.damage,
		["aggroRange"] = unit.config.aggroRange,
		["maxHealth"] = unit.maxHealth,
		["currentHealth"] = unit.currentHealth,
		["damageType"] = unit.config.damageType,
		["sword"] = unit.config.sword,
		["equipment"] = unit.config.equipment,
		["walkSpeed"] = unit.config.walkSpeed,
		["cell"] = unit.currentCell,
		["facing"] = unit.currentFacing
	}
	
	return data
end

function module.toStructureOutbound(unit, definition)
	
end

return module
