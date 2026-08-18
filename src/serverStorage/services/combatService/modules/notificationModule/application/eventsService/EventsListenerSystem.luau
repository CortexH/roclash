local module = {}

local applies = {
	require(script.Parent.systems.UnitLifecycleNotifySystem._UnitLifecycleNotifySystem)
}

function module.execute(event, context)
	local returnedEvents = {}

	for _, system in ipairs(applies) do
		if system.applies[event.eventType] then
			local produced = system.applies[event.eventType](event, context) or {}

			for _, newEvent in produced do
				table.insert(returnedEvents, newEvent)
			end
		end
	end

	return returnedEvents
end

return module
