local module = {}

local domain = script.Parent.Parent

local position = require(domain.valueObjects.Position)
local unitEntity = require(domain.entity.UnitEntity)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.validateUnitPlacement(
	cell : {x:number, y:number},
	rotation : number,
	ownerId : string,
	behavior : string,
	unitId,
	context
)
	
	local unitsBC = context["UnitsBC"]
	
	if rotation < 0 or rotation > 3 or rotation % 1 ~= 0 then
		return false, "Rotation deve ser um número inteiro entre 0 e 3"
	end
	
	if behavior ~= "AGGRESSIVE" and behavior ~= "DEFENSIVE" and behavior ~= "PEACEFUL" then
		return false, "Behavior deve ser 'AGGRESSIVE', 'DEFENSIVE' ou 'PEACEFUL'"
	end
	
	if not mapPort.isCellValid(cell) then
		return false, "Posição inválida"
	end
	
	local unit : unitEntity.unitEntity = unitsBC:getReservedUnitById(unitId)
	
	if not unit then 
		return false, "Unit com id " .. unitId .. " não encontrada" 
	end
	
	if tostring(unit.owner) ~= tostring(ownerId) then
		return false, "Unit não é do jogador"
	end
	
	local unitsInCell = unitsBC:getActiveUnitByCell(cell)
	
	for _, v : unitEntity.unitEntity in unitsInCell do
		if unit:verifyPlacementInBlockType(v:getNpcConfig():getBlockCellType()) then
			return false, "Célula já obstruída para spawn de npc"
		end
	end
	
	return true
end

return module
