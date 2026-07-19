local module = {}

local eventsAdapter = require(script.Parent.infrastructure.adapter.inbound.controller.NpcEventDispatcher)

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
	local controller = script.Parent.infrastructure.adapter.inbound.controller

	require(controller.adapter.BrainController)

	local api = script.Parent.infrastructure.adapter.outbound.gateway

	require(api.BattleViewPortImpl)
	require(api.BrainPortImpl)
	require(api.MapPortImpl)

end

runBootstrap()


return module
