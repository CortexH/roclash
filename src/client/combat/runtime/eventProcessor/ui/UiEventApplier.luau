local module = {}

local applies = {
	require(script.Parent.appliers.ScreenFlowApplier._ScreenFlowApplier),
	require(script.Parent.appliers.UnitCardApplier._UnitCardApplier),
	require(script.Parent.appliers.SpawnUnitUIApplier._SpawnUnitUIApplier),
	require(script.Parent.appliers.UnitHoverApplier._UnitHoverApplier),
}

function module.execute(event)
	for _, applier in ipairs(applies) do
		if applier.applies[event.eventType] then
			applier.applies[event.eventType](event)
		end
	end
end

return module