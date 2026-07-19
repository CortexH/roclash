local module = {}

local applies = {
	require(script.Parent.appliers.NpcLifecycleApplier._NpcLifecycleApplier),
	require(script.Parent.appliers.NpcAggroApplier._NpcAggroApplier),
	require(script.Parent.appliers.NpcTargetingApplier._NpcTargetingApplier)
}

function module.execute(event, context)
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			applier.applies[event.eventType](event, context)
		end
	end
end

return module
