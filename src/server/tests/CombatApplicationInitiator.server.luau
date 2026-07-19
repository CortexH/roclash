local combatService = require(game.ServerStorage.Server.services.combatService.CombatApplication)
local attackerData = require(game.ServerStorage.Server.testing.AttackerData)

local api = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes)

game:GetService("Players").PlayerAdded:Connect(function(player)
	task.wait(0.1)
	local ct = combatService.beginCombat(player.UserId, 504127685, 1, attackerData.generateData(15))
	api.start.loadBattle:FireClient(player, ct)
end)
