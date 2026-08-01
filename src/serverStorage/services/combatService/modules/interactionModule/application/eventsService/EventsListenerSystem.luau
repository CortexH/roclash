local module = {}

local applies = {
	require(script.Parent.systems.UnitSelectSystem._UnitSelectSystem),
}

function module.execute(event, context)
	local returnedEvents = {}
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			local produced = applier.applies[event.eventType](event, context) or {}
			for _, newEvent in produced do
				table.insert(returnedEvents, newEvent)
			end
		end
	end
	return returnedEvents
end

return module
