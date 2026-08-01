local module = {}

local viewPort = require(script.Parent.Parent.Parent.ports.BattleViewPort)

function module.canPerformAction(unitId: string, targetId: string, context: any, range: number)

    local selfView = viewPort.getSelfBattleView(unitId, context)
    local targetView = viewPort.getUnitBattleView(unitId, targetId, context)

    -- 1. Validação Básica de Existência e Vida
    if not selfView or not selfView.isAlive then return false, "SOURCE_INVALID" end
    if not targetView or not targetView.isAlive then return false, "TARGET_INVALID" end

    -- 2. Validação de Estado do Atacante
    if not selfView.isPlaced then return false, "SOURCE_NOT_PLACED" end
    --if selfView.cooldownRemaining > 0 then return false, "ON_COOLDOWN" end

    -- 3. Validação de Alvo (Contexto de Combate)
    if not targetView.isPlaced then return false, "TARGET_NOT_PLACED" end
    if not targetView.isEnemy then return false, "TARGET_NOT_ENEMY" end -- Não atacar aliados

    -- 4. Validação de Range (Usando o dado calculado no ViewPort)
    if targetView.distanceToSelf > range then
        return false, "OUT_OF_RANGE"
    end

    return true, nil
end

return module

