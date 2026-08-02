local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local AggroValidator = require(domain.service.Validator.AggroValidator)
local aggroEvents = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AggroIntentEvent)
local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local function createRejected(source, target, reason, origin)
    return {
        eventType = "AggroIntentRejected",
        type = "EVENT",
        delay = 0,
        isValid = true,
        data = {
            source = source,
            target = target,
            reason = reason,
            origin = origin
        }
    }
end

local function createAccepted(source, target)
    return {
        eventType = "AggroIntentAccepted",
        type = "EVENT",
        delay = 0,
        isValid = true,
        data = {
            source = source,
            target = target
        }
    }
end

function module.handle(event: intentTypes.AggroIntent, context: any)
    local unitId = event.data.source
    local targetId = event.data.target
    local policy = event.data.policy
    local origin = event.data.origin

    -- 1. Validação de entrada
    if not unitId or not targetId then
        return {createRejected(unitId, targetId, "INVALID_INPUT", origin)}
    end

    -- 1.1 Guard de idempotência: se a unidade já está aggroando este mesmo alvo,
    -- não re-emitir o aggro (evita o ciclo de re-aggro que gera avalanches de
    -- UnitAggroStartedEvent a cada ataque resolvido).
    local brain = brainPort.getNpcBrain(unitId, context)
    if brain and brain:getAggro() then
        local currentAggro = brain:getAggro():getCurrentAggro()
        if currentAggro == targetId then
            return {}
        end
    end

    -- 2. Pegamos a SelfBattleView
    local selfView = viewPort.getSelfBattleView(unitId, context)
    if not selfView then
        return {createRejected(unitId, targetId, "SOURCE_VIEW_NOT_FOUND", origin)}
    end

    -- 3. Validação completa usando AggroValidator
    local success, reason = AggroValidator.validateAggro(unitId, targetId, context, policy, selfView.aggroRange)

    if success then
        return {createAccepted(unitId, targetId)}
    else
        return {createRejected(unitId, targetId, reason, origin)}
    end
end

return module