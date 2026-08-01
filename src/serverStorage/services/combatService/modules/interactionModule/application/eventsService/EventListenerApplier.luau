local module = {}

local applies = {
	require(script.Parent.appliers.UnitSelectApplier._UnitSelectApplier)
}

function module.execute(event, context)
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			applier.applies[event.eventType](event, context)
		end
	end
end

return module
