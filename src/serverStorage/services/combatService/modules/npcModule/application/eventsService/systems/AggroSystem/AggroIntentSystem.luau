local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local IntentValidator = require(domain.service.Validator.IntentValidator)
local viewPort = require(domain.ports.BattleViewPort)
local aggroEvents = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

-- Função utilitária interna para padronizar as respostas
local function createResponse(eventType, data)
    return { { eventType = eventType, data = data } }
end

function module.handle(event: aggroEvents.unitAggroIntentEvent, context: any)
    local unitId = event.data.unitId
    local targetId = event.data.targetId

    -- 1. Validação de entrada
    if not unitId or not targetId then
        return createResponse("UnitAggroIntentRejected", { unitId = unitId, targetId = targetId, reason = "INVALID_INPUT" })
    end

    -- 2. Pegamos a SelfBattleView
    local selfView = viewPort.getSelfBattleView(unitId, context)
    if not selfView then
        return createResponse("UnitAggroIntentRejected", { unitId = unitId, targetId = targetId, reason = "SOURCE_VIEW_NOT_FOUND" })
    end

    -- 3. Validação de aggroRange
    local aggroRange = selfView.aggroRange
    if not aggroRange or aggroRange <= 0 then
        return createResponse("UnitAggroIntentRejected", { unitId = unitId, targetId = targetId, reason = "INVALID_AGGRO_RANGE" })
    end

    -- 4. Validação de negócio
    local success, reason = IntentValidator.canPerformAction(unitId, targetId, context, aggroRange)

    if success then
        return createResponse("UnitAggroStartedEvent", {
            aggroingUnitId = unitId,
            aggroedUnitId = targetId,
            aggroingUnitMovementVersion = "",
            aggroedUnitMovementVersion = ""
        })
    else
        return createResponse("UnitAggroIntentRejected", {
            unitId = unitId,
            targetId = targetId,
            reason = reason
        })
    end
end

return module