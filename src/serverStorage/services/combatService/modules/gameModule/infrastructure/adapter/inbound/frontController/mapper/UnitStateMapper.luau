local module = {}

local unitEntity = require(game.ServerStorage.Server.services.combatService.modules.entityModule.domain.entity.UnitEntity)
local stateType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitStateDataType)

function module.toFront(unit : unitEntity.unitEntity)
	
	local data : stateType.unitState = {
		unitId = unit:getId(),
		placed = {
			isPlaced = unit.placed,
			position = unit:getPosition():getCurrentPosition(),
			cell = unit:getCurrentCell(),
			rotation = unit.currentFacing
		},
		status = {
			maxHealth = unit.maxHealth,
			currentHealth = unit.currentHealth,
			aggroRange = unit:getNpcConfig():getAggroRange() or nil,
			isDead = unit:isDead(),
		},
		currentEffects = {}
	}
	
	if unit:getAttacker() then
		data.status.attackRange = unit:getAttacker():getRange()
	end

	
	return data
end

return module
