local module = {}

local query = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.queries.UnitSelectQuery)
local entityDomain = game.ServerStorage.Server.services.combatService.modules.entityModule.domain

local unitEntity = require(entityDomain.entity.UnitEntity)

function module.handle(event : query.UnitSelectQuerySuccess, context)
    local sessionBC = context["PlayerSessionBC"]
    sessionBC:addSelectedEntity(event.data.unitId)
end

return module