local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local eventService = require(domain.service.NpcEventFactory)
local brainPort = require(domain.ports.NpcBrainPort)

-- Este sistema lida com falhas na intenção de ataque.
-- Se o ataque falhou por estar fora de range, podemos tentar reavaliar o alvo.
function module.handle(event, context)
    if event.isValid == false then return {} end

    local unitId = event.data.source
    local reason = event.data.reason

    if reason == "OUT_OF_RANGE" then
        -- Aqui o cérebro poderia decidir:
        -- 1. Tentar mover para o alvo (disparar MovementRequest)
        -- 2. Procurar outro alvo mais próximo (disparar AggroSearch)
        -- Por enquanto, como o movimento está ligado ao Aggro, 
        -- vamos apenas logar ou disparar um evento de "Reavaliação"
        return {}
    end

    return {}
end

return module
