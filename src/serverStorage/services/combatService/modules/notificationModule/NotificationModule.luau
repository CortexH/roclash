local module = {}

local eventsAdapter = require(script.Parent.infrastructure.adapter.inbound.controller.NotificationEventDispatcher)

function module.applyEvent(_event, _context)
	-- Notification events do not own or mutate BattleContext state.
end

function module.handleEvent(event, context)
	local returnedEvents = eventsAdapter.getSystem().execute(event, context)
	local realEvents = {}

	for _, notificationEvent in returnedEvents do
		table.insert(realEvents, {
			targetQueue = context["IdentityBC"]["attackerPlayerId"],
			event = notificationEvent
		})
	end

	return realEvents
end

return module
