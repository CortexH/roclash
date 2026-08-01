local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AttackIntentEvent)

function module.handle(event : intentTypes.AttackIntentAccepted, context)
    local unitId = event.data.source
    local targetId = event.data.target.id

    return {{
        delay = 0,
        eventType = "AttackStartedEvent",
        type = "EVENT",
        data = {
            attackerId = unitId,
            targetId = targetId
        },
        isValid = true
    }}
end

return module