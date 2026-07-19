local main = {}

local adapter = require(script.Parent.infrastructure.adapter.inbound.controller.SnapshotController)

local domain = script.Parent.domain

local mapsConsts = require(domain.ports.MapsConstsPort)
local consts = require(domain.ports.ConstsDataPort)

local counter = 1

function main.loadMapData(context)
	local playerData = adapter.loadMapData(context)
	context["ConstsBC"].mapConsts["mapId"] = playerData.snapshotMapId
	return playerData
end

function main.updateContextData(context)
	
	local mapId = context["ConstsBC"].mapConsts["mapId"]
	
	local firstX, firstY = consts.getFirstCornerPosition()
	local lastX, lastY = consts.getLastCornerPosition()
	
	context["ConstsBC"].mapConsts = {
		mapId = mapId,
		cellSize = mapsConsts.getMapDataConstsById(mapId).cellSize,
		firstCornerPosition = {x = firstX, y = firstY},
		lastCornerPosition = {x = lastX, y = lastY}
	}
end

function runBootstrap()
	local frontController = script.Parent.infrastructure.adapter.inbound.controller

	require(frontController.MapModuleAPIImpl)
	require(frontController.MapConstsController)
	require(frontController.SnapshotController)

	local api = script.Parent.infrastructure.adapter.outbound

	require(api.gateway.ConstsGatewayImpl)
	require(api.gateway.MapDataConstsGatewayImpl)

	require(api.persistence.ContextDataPortImpl)
	require(api.persistence.SnapshotDataPortImpl)

end

runBootstrap()


return main
