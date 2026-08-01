local module = {}

local applies = {
	require(script.Parent.appliers.eventValidator._EventValidatorApplier),
	--require(script.Parent.appliers._GenericStatsApplier),
	require(script.Parent.appliers.UnitPosition._UnitPositionApplier),
	require(script.Parent.appliers.UnitLifecycle._UnitLifecycleApplier),
	require(script.Parent.appliers.unitCombat._UnitCombatApplier),
	require(script.Parent.appliers.unitIntent._UnitIntentApplier)
}

function module.execute(event, context)
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			applier.applies[event.eventType](event, context)
		end
	end
end

return module
