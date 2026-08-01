local module = {}

local appliers = {
	require(script.Parent.client.ClientEventApplier),
	require(script.Parent.ui.UiEventApplier),
	require(script.Parent.interaction.InteractionApplier)
}
local systems = {
	require(script.Parent.client.ClientEventListenerSystem)
}

function module.handle(event)

	for _, v in appliers do
		v.execute(event)
	end

	local createdEvents = {}

	for _, v in systems do
		local newEvents = v.execute(event)
		for _, newEvent in newEvents do
			table.insert(createdEvents, newEvent)
		end
	end

	return createdEvents
end

return module
