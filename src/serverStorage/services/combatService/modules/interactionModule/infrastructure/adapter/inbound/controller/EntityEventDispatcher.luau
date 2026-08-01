local module = {}

local eventListenerApplier = require(game.ServerStorage.Server.services.combatService.modules.interactionModule.application.eventsService.EventListenerApplier)
local eventListenerSystem = require(game.ServerStorage.Server.services.combatService.modules.interactionModule.application.eventsService.EventsListenerSystem)

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