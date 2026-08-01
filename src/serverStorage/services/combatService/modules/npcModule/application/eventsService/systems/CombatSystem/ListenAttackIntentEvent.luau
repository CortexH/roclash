local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventService = require(domain.service.NpcEventFactory)
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AttackIntentEvent)

local viewPort = require(domain.ports.BattleViewPort)

-- Este sistema valida a intenção de ataque antes de autorizar o ataque real.
function module.handle(event : intentTypes.AttackIntent, context)
    if event.isValid == false then return {} end

    local unitId = event.data.source
    local targetId = event.data.target.id
    local targetPos = event.data.target.position

    local selfView = viewPort.getSelfBattleView(unitId, context)

    if not selfView then
        return { eventService.createAttackIntentFailed(unitId, targetId, "INVALID_SELF", "SYSTEM", nil) }
    end

    if not selfView.canAttack then
        return { eventService.createAttackIntentFailed(unitId, targetId, "CANNOT_ATTACK", "SYSTEM", nil) }
    end

    local targetView = viewPort.getUnitBattleView(unitId, targetId, context)
    print("Target View for targetId:", targetId, "is", targetView)
    if not targetView or not targetView.isAlive then
        return { eventService.createAttackIntentFailed(unitId, targetId, "TARGET_DEAD", "SYSTEM", nil) }
    end

    -- 3. Verifica o Range (usando a função isInRange que já temos na UnitEntity)
    if not targetView.inRange then
        return {
            eventService.createAttackIntentFailed(unitId, targetId, "OUT_OF_RANGE", "SYSTEM", nil)
        }
    end

    return {
        eventService.createAttackIntentAccepted(event.data.source, event.data.target)
    }
end

return module

