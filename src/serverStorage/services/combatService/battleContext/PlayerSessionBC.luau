local module = {}

module.__index = module

module.contextName = "PlayerSessionBC"

function module.new(playerId, opponentId, snapshotNumber, attackerData, battleId)
	return setmetatable({

        playerId = playerId,
        opponentId = opponentId,
        battleId = battleId,

        selectedEntities = {}

    }, module)
end

function module:getSelectedEntities()
    return self.selectedEntities
end

function module:setSelectedEntities(entities)
    self.selectedEntities = entities
end

function module:addSelectedEntity(entityId)
    table.insert(self.selectedEntities, entityId)
end

return module