local module = {}

local renderEventType = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.queryResponse.SelectQueryResponse)

function translateSelectQuery(event, currentTime)

    local translatedEvent = {
        eventType = "UnitSelectQuerySuccessResponse",
        delay = event.delay,
        data = {
            unitId = event.data.unitId,
            unitName = event.data.unitName,
            unitType = event.data.unitType,
            stats = {
                health = event.data.stats.health,
                maxHealth = event.data.stats.maxHealth
            },
            attacker = event.data.attacker and {
                damage = event.data.attacker.damage,
                attackRange = event.data.attacker.attackRange,
                attackSpeed = event.data.attacker.attackSpeed
            } or nil,
            npcUnit = event.data.npcUnit and {
                weapon = event.data.npcUnit.weapon,
                equipment = event.data.npcUnit.equipment,
                behavior = event.data.npcUnit.behavior,
                aggroRange = event.data.npcUnit.aggroRange,
                walkspeed = event.data.npcUnit.walkspeed
            } or nil,
            structureUnit = event.data.structureUnit and {
                structureType = event.data.structureUnit.structureType
            } or nil,
            canTarget = event.data.canTarget,
            canMove = event.data.canMove
        }
    }

    return translatedEvent
end

module.translators = {
    ["UnitSelectQuerySuccess"] = translateSelectQuery
}

function module.translateEvent(event, currentTime)
    local translator = module.translators[event.eventType]
    if not translator then
        return nil
    end
    return translator(event, currentTime)
end

function module.translateEvents(events, currentTime)
    local translatedEvents = {}
    
    for _, v in events do
        local translatedEvent = module.translateEvent(v, currentTime)
        if not translatedEvent then continue end
        table.insert(translatedEvents, translatedEvent)
    end
    
    return translatedEvents
end

return module