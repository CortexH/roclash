local module = {}

local unitEntity = require(game.ServerStorage.Server.services.combatService.modules.entityModule.domain.entity.UnitEntity)
local definitionType = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitDefinitionDataType)

function module.toFront(unit : unitEntity.unitEntity)
	
	local data : definitionType.unitDefinition = {
		unitId = unit:getId(),
		unitType = unit:getNpcConfig():getUnitType(),
		party = unit:getParty(),
		blockCellType = unit:getNpcConfig():getBlockCellType(),
		unitOwner = unit.owner
	}
	
	if unit:getNpcConfig():getUnitType() == "NPC" then
		data.npcExclusive = {
			weapon = unit:getNpcConfig().sword,
			equipment = unit:getNpcConfig().equipment,
			animations = {
				-- TODO: adicionar animações
			}
		}
	elseif unit:getNpcConfig():getUnitType() == "STRUCTURE" then
		data.structureExclusive = {
			structureTypeId = unit:getStructureConfig().structureType
		}
	end
	
	return data
	
end

return module
