local module = {}

local playerService = game:GetService("Players")

local endpoint = require(game.ServerStorage.Server.services.combatService.API.frontEnd.Remotes)
local contracts = require(game.ServerStorage.Server.services.combatService.API.frontEnd.Contracts)

local api = require(game.ServerStorage.Server.services.combatService.API.gameModule.GameModuleDataAPI)

local unitEntity = require(game.ServerStorage.Server.services.combatService.modules.entityModule.domain.entity.UnitEntity)

local definitionMapper = require(script.Parent.Parent.mapper.UnitDefinitionMapper)
local stateMapper = require(script.Parent.Parent.mapper.UnitStateMapper)

api.sendPlayerFirstData = function(context)
	local sendData : contracts.loadDataContract = {
		units = {},
		map = getMapConstsData(context)
	}

	local allUnits = context["UnitsBC"]:getAllUnits()

	for _, v in allUnits do
		local definition, state = translateUnitData(v)

		sendData.units[v:getId()] = {
			definition = definition,
			state = state
		}

	end

	endpoint.data.toFront.loadData:FireClient(playerService:GetPlayerByUserId(context["IdentityBC"].attackerPlayerId), sendData)

	return true
end

function translateUnitData(unit)
	return definitionMapper.toFront(unit), stateMapper.toFront(unit)
end

function getMapConstsData(context)
	local data = {
		["mapId"] = context["ConstsBC"]["mapConsts"].mapId,
		["cellSize"] = context["ConstsBC"]["mapConsts"].cellSize,
		["battleFieldFirstCornerPosition"] = context["ConstsBC"]["mapConsts"].firstCornerPosition,
		["battleFieldLastCornerPosition"] = context["ConstsBC"]["mapConsts"].lastCornerPosition
	}
	
	return data
end

return module
