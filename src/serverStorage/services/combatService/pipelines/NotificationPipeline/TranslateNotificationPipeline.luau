local module = {}

local notificationEventType = require(
	game.ServerStorage.Server.services.combatService.shared.eventTypes.NotificationEvents
)
local frontEventType = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

function module.translateEvent(
	event : notificationEventType.unitDiedNotificationEvent
) : frontEventType.unitDiedNotification
	return {
		eventType = "UnitDiedNotificationEvent",
		time = event.time,
		data = {
			unitId = event.data.unitId,
			killerUnitId = event.data.killerUnitId
		}
	}
end

return module
