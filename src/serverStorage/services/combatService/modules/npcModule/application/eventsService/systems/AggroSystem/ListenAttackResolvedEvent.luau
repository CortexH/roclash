local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AggroIntentEvent)

function module.handle(event : combatEventTypes.attackResolvedEvent, context)
	
    return {{
        ["delay"] = 0,
        ["eventType"] = "UnitAggroSearchEvent",
        ["type"] = "EVENT",
        ["data"] = {
            ["aggroingUnitId"] = event.data.attackerId,
            --["aggroVersion"] = string,
        },
        ["isValid"] = true
    }}

end

return module
