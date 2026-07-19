local module = {}

local domain = script.Parent.Parent
local unitEntity = require(domain.entity.UnitEntity)
local mathService = require(domain.domainService.MathService)

local mapPort = require(domain.ports.gateways.MapGatewayPort)

function module.timeToMoveToCell(unit : unitEntity.unitEntity, beginCell, endCell)
	local movementSpeed = module.getUnitWalkSpeed(unit)
	if not movementSpeed then return end
	
	local beginPos, endPos = mapPort.getPositionFromCell(beginCell), mapPort.getPositionFromCell(endCell)
	
	return mathService.getTravelTime(beginPos, endPos, movementSpeed)
end

function module.timeToMoveToPosition(unit : unitEntity.unitEntity, beginPos, endPos)
	local movementSpeed = module.getUnitWalkSpeed(unit)
	if not movementSpeed then return end	
	return mathService.getTravelTime(beginPos, endPos, movementSpeed)
end

function module.getUnitWalkSpeed(unit : unitEntity.unitEntity)
	return unit:getNpcConfig():getWalkSpeed()
end

return module
