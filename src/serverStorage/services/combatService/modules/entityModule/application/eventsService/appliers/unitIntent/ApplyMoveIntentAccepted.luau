local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.MoveIntentEvent)

local unitEntity = require(domain.entity.UnitEntity)

-- MoveIntentAcceptedHandler
-- Incrementa a movementVersion da unit quando um novo movimento é aceito.
-- Isso invalida os eventos de movimento obsoletos ainda pendentes na fila
-- (UnitMovementStartedEvent/UnitMovementResolvedEvent/VerifyAggroReachedEvent
-- da cadeia anterior), evitando que uma unit seja teleportada para o caminho
-- antigo ao receber um novo comando de movimento.
function module.apply(event : intentTypes.MoveIntentAccepted, context)
	if event.isValid == false then return end
    local unit : unitEntity.unitEntity = context["UnitsBC"]:getActiveUnitById(event.data.unitId)
    if not unit then return end
    unit:getAttacker():getVersioning():incrementMovementVersion()
end

return module
