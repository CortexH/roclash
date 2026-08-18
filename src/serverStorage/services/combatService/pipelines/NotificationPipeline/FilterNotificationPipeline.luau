local module = {}

local enabledEvents = {
	["UnitDiedNotificationEvent"] = true
}

function module.filterEvent(event)
	return enabledEvents[event.eventType] == true
end

return module
