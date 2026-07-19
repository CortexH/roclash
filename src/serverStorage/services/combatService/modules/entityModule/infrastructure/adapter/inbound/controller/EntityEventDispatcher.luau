local module = {}

local entityEvent = require(game.ServerStorage.Server.services.combatService.modules.entityModule.domain.events.EntityEvent)
local entityCommand = require(game.ServerStorage.Server.services.combatService.modules.entityModule.domain.events.EntityCommand)

local eventListenerApplier = require(game.ServerStorage.Server.services.combatService.modules.entityModule.application.eventsService.EventListenerApplier)
local eventListenerSystem = require(game.ServerStorage.Server.services.combatService.modules.entityModule.application.eventsService.EventsListenerSystem)

function module.handle(event, context)
	eventListenerApplier.execute(event, context)
	return eventListenerSystem.execute(event, context)
end

function module.getApplier()
	return eventListenerApplier
end

function module.getSystem() : typeof(eventListenerSystem)
	return eventListenerSystem
end

return module
