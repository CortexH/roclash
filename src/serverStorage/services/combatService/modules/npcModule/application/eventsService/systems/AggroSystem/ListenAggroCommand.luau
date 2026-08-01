local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local commandTypes = require(script.Parent.Parent.Parent.Parent.service.events.NpcCommands)
local aggroEvents = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

local viewPort = require(domain.ports.BattleViewPort)


function module.handleEvent(event : commandTypes.UnitAggroCommand, context)
	
    local self = viewPort.getSelfBattleView(event.data.unitId, context)
    local target = viewPort.getUnitBattleView(event.data.unitId, event.data.targetId, context)

    if not self.isAlive then return {generateCommandFailEvent("SELF_DIED")} end
    if not self.isPlaced then return {generateCommandFailEvent("SELF_NOT_PLACED")} end

	if not target.isAlive then return {generateCommandFailEvent("TARGET_DIED")} end
    if not target.isPlaced then return {generateCommandFailEvent("TARGET_NOT_PLACED")} end
    if not target.isEnemy then return {generateCommandFailEvent("TARGET_NOT_ENEMY")} end
    
    local aggroIntent = {
        delay = 0,
        eventType = "UnitAggroIntentEvent",
        type = "EVENT",
        data = {
            source = event.data.unitId,
            target = event.data.targetId,
            origin = {
                type = "PLAYER",
                playerId = event.data.playerId
            },
            policy = "COMMAND"
        },
        isValid = true
    }
    
    return {aggroIntent}

end

function generateCommandFailEvent(reason : string, event, context)
    return {
        delay = 0,
        eventType = "UnitAggroCommandFail",
        type = "EVENT",
        data = {
            unitId = event.data.unitId,
            targetId = event.data.targetId,
            reason = reason
        }
    }
end

return module
