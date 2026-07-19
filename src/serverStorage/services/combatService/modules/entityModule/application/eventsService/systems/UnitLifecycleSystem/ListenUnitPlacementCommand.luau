local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local unitEntity = require(domain.entity.UnitEntity)
local unitCommands = require(domain.events.EntityCommand)

local mapAPI = require(domain.ports.gateways.MapGatewayPort)

local unitPlacementService = require(domain.domainService.UnitPlacementService)

-- TODO: realizar testes para verificar integridade das validações
function module.handle(command : unitCommands.unitPlacementCommand, context)
	local unitsBC = context["UnitsBC"]

	local responses = {}

	for i, v in command.data do
		local validationSuc, validationFault = validateCommandPayload(v, i)
		
		if not validationSuc then 
			table.insert(responses, failCommand(v, validationFault))
			continue 
		end
		
		local placementSuc, unitPlaceMsg = unitPlacementService.validateUnitPlacement(
			v.position,
			0, 
			command.requesterId, 
			v.behavior,
			v.entityId,
			context
		)
		
		if not placementSuc then table.insert(responses, failCommand(v, unitPlaceMsg)) continue end
		
		local unit : unitEntity.unitEntity = unitsBC:getReservedUnitById(v.entityId)
		
		table.insert(responses, successCommand(v))
		table.insert(responses, createEvent(v, unit))
	end

	return responses

end

function validateCommandPayload(data, index) : (boolean, {[string] : string})

	if not data.entityId then
		return false, "Entidade de index '" .. index .. "' sem entityId" 
	end
	if not data.position then 
		return false, "dados do evento com 'position' nulo"
	end
	if not data.behavior then 
		return false, "dados do evento com 'Behavior' nulo"
	end

		
	if (not data.position["x"]) 
		or (not data.position["y"]) 
		or (type(data.position["x"]) ~= "number") 
		or (type(data.position["y"]) ~= "number")
	then
		return false, "Unit com posição inválida"
	end	

	return true
end

function failCommand(eventData, reason)
	return {
		eventType = "UnitPlacementCommandResponse",
		type = "COMMAND_RESPONSE",
		shouldRender = true,
		delay = 0,
		data = {
			["commandResponseType"] = "FAIL",
			["reason"] = reason,
			["eventData"] = eventData
		}
	}
end

function successCommand(eventData)
	return {
		eventType = "UnitPlacementCommandResponse",
		type = "COMMAND_RESPONSE",
		shouldRender = true,
		delay = 0,
		data = {
			["commandResponseType"] = "SUCCESS",
			["entityId"] = eventData.entityId,
			["success"] = {
				["entityId"] = eventData.entityId,
				["position"] = eventData.position,
				["behavior"] = eventData.behavior
			}
		}
	}
end

function createEvent(eventData, unit : unitEntity.unitEntity)

	local unitType = unit.config:getUnitType()
	local structureType = unit.config.structureType

	return {
		eventType = "UnitSpawnedEvent",
		delay = 0,
		data = {
			["entityId"] = eventData.entityId,
			["position"] = eventData.position,
			["behavior"] = eventData.behavior,
			["rotation"] = 0, -- TODO: Alterar estrutura para 'rotation' poder receber valores
			["reason"] = "SUMMON",
			["type"] = {
				["unitType"] = unitType,
				["structureTypeId"] = structureType
			}
		}
	}
end

-- utils

function getTableSize(t)
	local count = 0
	for _, _ in pairs(t) do
		count += 1
	end
	return count
end


return module
