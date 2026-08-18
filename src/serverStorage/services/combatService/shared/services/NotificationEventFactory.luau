local module = {}

local notificationEventType = require(script.Parent.Parent.eventTypes.NotificationEvents)

function module.createUnitDiedNotificationEvent(
	unitId : string,
	killerUnitId : string
) : notificationEventType.unitDiedNotificationEvent
	return {
		eventType = "UnitDiedNotificationEvent",
		delay = 0,
		type = "EVENT",
		data = {
			unitId = unitId,
			killerUnitId = killerUnitId
		}
	}
end

return module
