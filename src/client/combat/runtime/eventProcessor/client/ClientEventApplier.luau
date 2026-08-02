local module = {}

local applies = {
	require(script.Parent.appliers.UnitLifecycleClientApplier._UnitLifecycleClientApplier),
	require(script.Parent.appliers.UnitCmdResponsesApplier._UnitCmdResponsesApplier),
	require(script.Parent.appliers.UnitMovementClientApplier._UnitMovementClientApplier),
	require(script.Parent.appliers.UnitCombatClientApplier._UnitCombatClientApplier),
	require(script.Parent.appliers.DamageIndicatorApplier._DamageIndicatorApplier)
}

function module.execute(event)
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			applier.applies[event.eventType](event)
		end
	end
end

return module
