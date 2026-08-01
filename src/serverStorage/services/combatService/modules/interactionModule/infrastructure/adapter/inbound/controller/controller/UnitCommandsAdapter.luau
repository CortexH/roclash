local module = {}

local commands = require(game.ServerStorage.Server.services.combatService.API.commands.UnitActionsCommands)
local commandTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.CommandTypes)

local enqueueEvent = require(game.ServerStorage.Server.services.combatService.API.eventQueue.EnqueueEvent)

commands.sendUnitMoveCommandRequest = function(player : Player, request : commandTypes.unitMoveCommand)
	
	local item = {
		event = {
			delay = 0,
			eventType = "UnitMoveCommand",
			type = "COMMAND",
			requesterId = tostring(player.UserId),
			data = {
				{
					unitId = request.unitId,
					position = request.targetCell
				}
			}
		},
		targetQueue = tostring(player.UserId),
		queueId = tostring(player.UserId)
	}
	
	enqueueEvent.enqueueEvent(item)
	
end

commands.sendUnitPlacementCommandRequest = function(player : Player, request : commandTypes.spawnUnitCommand)
	local item = {
		event = {
			eventType = "UnitPlacementCommand",
			type = "COMMAND",
			delay = 0,
			requesterId = tostring(player.UserId),
			data = request.units
		},
		targetQueue = tostring(player.UserId),
	}
	enqueueEvent.enqueueEvent(item)
end

commands.sendUnitAggroCommandRequest = function(player: Players, request : commandTypes.unitAggroCommand)
	local item = {
		event = {
			eventType = "UnitAggroCommand",
			type = "COMMAND",
			delay = 0,
			requesterId = tostring(player.UserId),
			data = {
				unitId = request.unitId,
				targetId = request.targetAggro
			}
		},
		targetQueue = tostring(player.UserId),
	}

	print(request)
	print(item)

	enqueueEvent.enqueueEvent(item)
end

return module
