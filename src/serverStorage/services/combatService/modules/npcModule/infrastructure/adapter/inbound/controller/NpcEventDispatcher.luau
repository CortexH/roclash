local module = {}

local eventSystem = require(script.Parent.Parent.Parent.Parent.Parent.application.eventsService.EventsListenerSystem)
local eventApplier = require(script.Parent.Parent.Parent.Parent.Parent.application.eventsService.EventListenerApplier)

function module.handle(event, context)
	eventApplier.execute(event, context)
	return eventSystem.execute(event, context)
end

function module.getApplier()
	return eventApplier
end

function module.getSystem()
	return eventSystem
end

return module
