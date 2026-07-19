local module = {}

module.__index = module

module.contextName = "IdentityBC"

function module.new(playerId, opponentId, snapshotNumber, attackerData, battleId)
	
	local self = setmetatable({}, module)
	
	self.battleId = battleId
	self.attackerPlayerId = tostring(playerId)
	self.defenderPlayerId = tostring(opponentId)
	self.snapshotNumber = snapshotNumber
	
	return self
	
end

return module
