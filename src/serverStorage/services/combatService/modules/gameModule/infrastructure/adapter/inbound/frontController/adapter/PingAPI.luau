local module = {}

local api = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes)

api.data.ping.OnServerEvent:Connect(function(player, type, clientTime)
	if type == "ping" then
		local serverTime = os.clock()
		api.data.ping:FireClient(player, "pong", clientTime, serverTime)
	end
end)

return module
