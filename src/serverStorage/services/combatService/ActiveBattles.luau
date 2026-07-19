local module = {}

local battleContext = require(script.Parent.battleContext.BattleContext)

module.activeBattles = {}

function module.getActiveBattles() : {battleContext.battleContext}
	return module.activeBattles
end

function module.getActiveBattle(playerId) : battleContext.battleContext
	return module.activeBattles[tostring(playerId)]
end

function module.addActiveBattle(playerId, battle) : nil
	module.activeBattles[tostring(playerId)] = battle
end

function module.removeActiveBattle(playerId) : nil
	module.activeBattles[tostring(playerId)] = nil
end

return module
