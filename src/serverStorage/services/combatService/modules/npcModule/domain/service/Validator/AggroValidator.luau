local module = {}

local IntentValidator = require(script.Parent.IntentValidator)
local viewPort = require(script.Parent.Parent.Parent.ports.BattleViewPort)

function module.validateAggro(unitId: string, targetId: string, context: any, policy: "COMMAND" | "AUTO", aggroRange: number?)
    if policy == "AUTO" and (not aggroRange or aggroRange <= 0) then
        return false, "INVALID_AGGRO_RANGE"
    end

    -- 1. Validações básicas herdadas do IntentValidator
    local success, reason = IntentValidator.canPerformAction(unitId, targetId, context, policy == "COMMAND" and math.huge or aggroRange)
    if not success then
        return false, reason
    end

    -- 2. Validação específica de aggroRange para policy AUTO
    if policy == "AUTO" then
        local targetView = viewPort.getUnitBattleView(unitId, targetId, context)

        if targetView.distanceToSelf > aggroRange then
            return false, "OUT_OF_AGGRO_RANGE"
        end
    end

    return true, nil
end

return module
