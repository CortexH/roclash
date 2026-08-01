local module = {}

local applies = {
	require(script.Parent.systems.SelectionSystem._SelectionSystem),
}

function module.execute(event)
	local returnedEvents = {}
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			local produced = applier.applies[event.eventType](event) or {}
			for _, newEvent in produced do
				table.insert(returnedEvents, newEvent)
			end
		end
	end
	return returnedEvents
end

return module
