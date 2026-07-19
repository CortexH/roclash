local module = {}


local applies = {
	require(script.Parent.appliers.ScreenFlowApplier._ScreenFlowApplier),
}

function module.execute(event)
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			applier.applies[event.eventType](event)
		end
	end
end

return module