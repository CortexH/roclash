local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AggroIntentEvent)
local unitEntity = require(domain.entity.UnitEntity)


function module.handle(event : intentTypes.AggroIntentAccepted, context)
    local unitId = event.data.source
    local targetId = event.data.target
    
    local unitsBC = context["UnitsBC"]
    local aggroingUnit : unitEntity.unitEntity = unitsBC:getActiveUnitById(unitId)
    local aggroedUnit : unitEntity.unitEntity = unitsBC:getActiveUnitById(targetId)
    
    local aggroingMovementVersion = aggroingUnit:getAttacker():getVersioning():getMovementVersion()
    local aggroedMovementVersion = nil

    if aggroedUnit:getAttacker() then
        aggroedMovementVersion = aggroedUnit:getAttacker():getVersioning():getMovementVersion()
    end
    
    return {{
        delay = 0,
        eventType = "UnitAggroStartedEvent",
        type = "EVENT",
        data = {
            aggroingUnitId = unitId,
            aggroedUnitId = targetId,
            aggroingUnitMovementVersion = tostring(aggroingMovementVersion),
            aggroedUnitMovementVersion = aggroedMovementVersion
        },
        isValid = true
    }}
end

return module
