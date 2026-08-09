local module = {}

local commands = require(game.ServerStorage.Server.services.combatService.API.queries.UnitQueries)
local commandTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.CommandTypes)

local enqueueEvent = require(game.ServerStorage.Server.services.combatService.API.eventQueue.EnqueueEvent)

commands.sendUnitSelectQueryRequest = function(player: Players, request : commandTypes.unitSelectCommand)
    local item = {
        event = {
            eventType = "UnitSelectQuery",
            type = "QUERY",
            delay = 0,
            signature = request.signature,
            requesterId = tostring(player.UserId),
            data = {
                unitId = request.unitId
            }
        },
        targetQueue = tostring(player.UserId),
    }
    enqueueEvent.enqueueEvent(item)
end

commands.sendUnitPathfindingQueryRequest = function(player: Players, request)
    local item = {
        event = {
            eventType = "UnitPathfindingQuery",
            type = "QUERY",
            delay = 0,
            signature = request.signature,
            requesterId = tostring(player.UserId),
            data = {
            	unitId = request.unitId,
            	start = request.start,
            	goal = request.goal,
            	goalUnitId = request.goalUnitId
            }
        },
        targetQueue = tostring(player.UserId),
    }
    enqueueEvent.enqueueEvent(item)
end

return module