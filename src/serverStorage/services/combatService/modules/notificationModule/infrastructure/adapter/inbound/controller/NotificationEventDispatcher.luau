local module = {}

local eventListenerSystem = require(
	game.ServerStorage.Server.services.combatService.modules.notificationModule.application.eventsService.EventsListenerSystem
)

function module.getSystem() : typeof(eventListenerSystem)
	return eventListenerSystem
end

return module
