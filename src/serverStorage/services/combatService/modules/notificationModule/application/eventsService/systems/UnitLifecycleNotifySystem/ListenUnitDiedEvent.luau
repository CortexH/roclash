local module = {}

local notificationEventFactory = require(
	game.ServerStorage.Server.services.combatService.shared.services.NotificationEventFactory
)

function module.handle(event, _context)
	return {
		notificationEventFactory.createUnitDiedNotificationEvent(
			event.data.targetId,
			event.data.sourceId
		)
	}
end

return module
