local module = {}

local adapter = require(script.Parent.infrastructure.adapter.inbound.controller.EntityController)
local eventsAdapter = require(script.Parent.infrastructure.adapter.inbound.controller.EntityEventDispatcher)

function module.loadEntities(context : {}, bruteData, attackerData)
	adapter.loadEntities(context, bruteData)
	adapter.loadNotPlacedUnits(context, attackerData)
end

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
	local gatewaysFolder = script.Parent.infrastructure.adapter.outbound.gateways
	require(gatewaysFolder.EntityDataPortImpl)
	require(gatewaysFolder.MapGatewayImpl)

	local controllers = script.Parent.infrastructure.adapter.inbound.controller.controller

	require(controllers.UnitCommandsAdapter)

end

runBootstrap()

return module
