local module = {}

local ports = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.ContextDataPort)

local activeBattles = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.ActiveBattles)

ports.updateBruteDataContext = function(playerId : number, data : {})
	activeBattles.getActiveBattle(playerId).bruteSnapshotContext = data
end

ports.updateMapDataToLoaded = function(playerId : number)

end


return module
