local module = {}

local eventsAPI = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes).commands.CommandSender

function module.sendCommand(command)
	eventsAPI:FireServer(command)
end

return module
