local module = {}

local services = script.Parent.Parent.Parent.Parent.Parent.application.services

local npcMapper = require(script.Parent.entity.Mapper.NpcEntityMapper)
local sendDataStructureMapper = require(script.Parent.entity.Mapper.SendDataStructureMapper)

local snapshotDataService = require(services.SnapshotDataService)
local positionService = require(services.PositionService)

local entityMapper = require(script.Parent.Parent.Parent.inbound.controller.entity.Mapper.StructureEntityMapper)

function module.loadMapData(context : {})
	return snapshotDataService.getSnapshotBruteData(
		context["IdentityBC"].defenderPlayerId,
		context["IdentityBC"].snapshotNumber
	)
end

return module
