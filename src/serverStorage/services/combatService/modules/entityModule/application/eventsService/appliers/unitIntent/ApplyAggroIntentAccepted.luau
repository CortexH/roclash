local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AggroIntentEvent)

local unitEntity = require(domain.entity.UnitEntity)

function module.apply(event : intentTypes.AggroIntentAccepted, context)
	if event.isValid == false then return end
    local unit : unitEntity.unitEntity = context["UnitsBC"]:getActiveUnitById(event.data.source)
    if not unit then return end
    unit:getAttacker():getVersioning():incrementMovementVersion()
end

return module
