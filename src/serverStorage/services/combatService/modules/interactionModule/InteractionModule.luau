local module = {}

local eventsAdapter = require(script.Parent.infrastructure.adapter.inbound.controller.EntityEventDispatcher)

function module.applyEvent(event, context)
	eventsAdapter.getApplier().execute(event, context)
end

function module.handleEvent(event, context)
	local returnedEvents = eventsAdapter.getSystem().execute(event, context)

	local realEvents = {}

	for _, v in returnedEvents do
		table.insert(realEvents, {
			targetQueue = context["IdentityBC"]["attackerPlayerId"],
			["event"] = v
		})
	end

	return realEvents
end
function runBootstrap()
	local controllers = script.Parent.infrastructure.adapter.inbound.controller.controller
	require(controllers.UnitCommandsAdapter)
	require(controllers.UnitActionsQuery)
end

runBootstrap()

return module