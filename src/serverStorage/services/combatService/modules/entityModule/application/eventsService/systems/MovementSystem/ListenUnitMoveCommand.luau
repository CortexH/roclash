local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local eventType = require(domain.events.EntityEvent)

local commandType = require(domain.events.EntityCommand)
local responseType = require(domain.events.EntityCommandResponse)

local movementService = require(domain.domainService.MovementDomainService)

local unitEntity = require(domain.entity.UnitEntity)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function generateErrorMessage(data, message : string)
	
	local item : responseType.unitMoveCommandResponse = {
		["eventType"] = "UnitMoveCommandResponse",
		["delay"] = 0,
		["type"] = "COMMAND_RESPONSE",
		["data"] = {
			["commandResponseType"] = "FAIL",
			["fault"] = {
				["entityId"] = data["unitId"],
				["reason"] = message
			}
		}
	}
	
	return item
	
end

function generateSuccessMessage(data)

	local item : responseType.unitMoveCommandResponse = {
		["eventType"] = "UnitMoveCommandResponse",
		["delay"] = 0,
		["type"] = "COMMAND_RESPONSE",
		["data"] = {
			["commandResponseType"] = "FAIL",
			["success"] = {
				["entityId"] = data["unitId"]
			}
		}
	}

	return item

end


function generateMoveEvent(v, unit : unitEntity.unitEntity)
	
	local item = {
		["eventType"] = "UnitMovementStartedEvent",
		["delay"] = 0,
		["type"] = "EVENT",
		["data"] = {
			["beginPosition"] = mapPort.getCellFromPosition(unit:getPosition():getCurrentPosition()),
			["finalPosition"] = v.position,
			["unitId"] = v.unitId,
			["unitVersion"] = unit:getAttacker():getVersioning():getMovementVersion(),
			["walkSpeed"] = unit:getNpcConfig():getWalkSpeed(),
			["movementTime"] = movementService.timeToMoveToCell(
				unit, unit.currentCell, v.position
			),
		}
	}
	
	return item
end

function module.handle(event : commandType.unitMoveCommand, context)
	local unitsBC = context["UnitsBC"]

	local events = {}

	for _, v in event.data do
		local validated, message = module.validateSingleEventData(v, context, event)
		if not validated then table.insert(events, generateErrorMessage(v, message)) continue end
		
		table.insert(events, generateSuccessMessage(v))
		table.insert(events, generateMoveEvent(v, unitsBC:getActiveUnitById(v.unitId)))

	end
	
end

function module.validateSingleEventData(data : {
	["unitId"] : string,
	["position"] : {x : number, y : number}
	}, context, command) : (boolean, string)
	
	local unitsBC = context["UnitsBC"]
	
	if not data.unitId then return false, "'unitId' is missing" end
	if not data.position then return false, "'position' is missing" end
	
	local unit : unitEntity.unitEntity = unitsBC:getActiveUnitById(data.unitId)
	
	if not unit then 
		local storedUnit = unitsBC:getReservedUnitById(data.unitId)
		if not storedUnit then
			return false, "Unit with id '" .. data.unitId .. "' does not exist"
		end
		return false, "Unit id " .. data.unitId .. " is not placed"
	end
	
	if not unit:isAttacker() then
		return false, "Unit id " .. data.unitId .. " cannot move"
	end
	
	if not unit:validateOwner(command.requesterId) then 
		return false, "Unit id " .. data.unitId .. " does not belong to player " .. command.requesterId
	end
	
	local suc, err = validatePosition(data.position)
	
	if not suc then return false, err end
	
	return true
	
end



function validatePosition(position : {x : number, y : number})
	
	if not position then return false, "'position' is missing" end
	if typeof(position) ~= "table" then return false, "'position' is not a table" end
	
	if not position.x then return false, "position.x is missing" end
	if not position.y then return false, "position.y is missing" end
	
	if typeof(position.x) ~= "number" then return false, "position.x is not a number" end
	if typeof(position.y) ~= "number" then return false, "position.y is not a number" end
	
	if not mapPort.isCellValid(position) then return false, "position is not valid" end
	
	-- TODO: colocar aqui uma validação para verificar se o jogador pode mover a unit para a celula
	-- em caso de ocupação (ex. tem uma torre na celula, então ele não pode mover a unit para lá)
	
	return true
	
end

return module
