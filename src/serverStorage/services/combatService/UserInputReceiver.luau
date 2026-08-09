local module = {}

local remote = require(game.ReplicatedStorage.Shared.combat.shared.API.Remotes)

local unitCommands = require(game.ServerStorage.Server.services.combatService.API.commands.UnitActionsCommands)
local unitQueries = require(game.ServerStorage.Server.services.combatService.API.queries.UnitQueries)

local handlers = {
	["UNIT"] = {
		-- COMMANDS
		["PLACE_UNIT"] = unitCommands.sendUnitPlacementCommandRequest,
		["MOVE_UNIT"] = unitCommands.sendUnitMoveCommandRequest,
		["AGGRO_UNIT"] = unitCommands.sendUnitAggroCommandRequest,

		-- QUERIES
		["SELECT_UNIT"] = unitQueries.sendUnitSelectQueryRequest,
		["PATHFIND_UNIT"] = unitQueries.sendUnitPathfindingQueryRequest
	}
}

remote.commands.CommandSender.OnServerEvent:Connect(function(player, command)
	if not handlers[command.target] then return end
	if not handlers[command.target][command.type] then return end
	handlers[command.target][command.type](player, command)
end)

return module
