local module = {}

local snapshotDataService = require(script.Parent.Parent.Parent.domain.ports.SnapshotDataPort)

local httpService = game:GetService("HttpService")

local ports = script.Parent.Parent.Parent.domain.ports

function module.loadSnapshotData(context : {})
	
	task.spawn(function()
		local data = snapshotDataService.getPlayerSnapshotData(context["opponent"].opponentId, context["opponent"].snapshotNumber)
		local newContext = table.clone(context)
		if not data then return end
		
		local user = context["userProfile"].playerId
		
		ports.contextDataPort.updateBruteDataContext(user, data)
		ports.contextDataPort.updateMapDataToLoaded(user)
	end)
	
	return context
	
end

function module.getSnapshotBruteData(opponentId, snapshotNumber)
	return snapshotDataService.getPlayerSnapshotData(opponentId, snapshotNumber)
end

function module.sendSnapshotDataToThePlayer(data : {}, playerId : number)
	return ports.snapshotDataPort.sendPlayerSnapshotData(data, playerId)
end

return module
