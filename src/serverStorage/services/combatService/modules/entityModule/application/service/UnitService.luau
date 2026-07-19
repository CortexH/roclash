local module = {}

local entityMapper = require(script.Parent.Parent.Parent.infrastructure.adapter.inbound.controller.mapper.StructureEntityMapper)

local unitEntityPath = script.Parent.Parent.Parent.domain.entity.UnitEntity

local unitEntity = require(unitEntityPath)
local unitConfig = require(unitEntityPath.Parent.UnitEntityAgg.UnitConfig)

local httpService = game:GetService("HttpService")

local buildConstsDTO = require(script.Parent.Parent.DTO.BuildConstsDTO)

local unitDTO = require(script.Parent.Parent.DTO.UnitDTO)
local unitConfigDTO = require(script.Parent.Parent.DTO.UnitConfigDTO)

local attackerStructureEntity = require(unitEntityPath.Parent.UnitEntityAgg.AttackerUnit)

local unitDamageVO = require(unitEntityPath.Parent.UnitEntityAgg.AttackerUnitAgg.UnitDamageVO)
local unitRangeVO = require(unitEntityPath.Parent.UnitEntityAgg.AttackerUnitAgg.UnitRangeVO)
local unitAttackSpeedVO = require(unitEntityPath.Parent.UnitEntityAgg.AttackerUnitAgg.UnitAttackSpeedVO)

local mapGateway = require(script.Parent.Parent.Parent.domain.ports.gateways.MapGatewayPort)


function module.buildDomainUnit(
	context,
	mappedEntity : unitDTO.unitDTO, 
	config : unitConfigDTO.structureConfig, 
	party : string,
	unitOwner : string,
	attackerConfig
) : unitEntity.unitEntity
		
	local attacker = attackerStructureEntity.new(
		mappedEntity.damage,
		mappedEntity.range,
		mappedEntity.attackSpeed,
		attackerConfig,
		context["ConstsBC"]["seed"]
	)
	
	local domainEntity = unitEntity.new(
		httpService:GenerateGUID(false),
		mappedEntity.maxHealth,
		mappedEntity.cell,
		mappedEntity.facing,
		attacker,
		party,
		mapGateway.getPositionFromCell(mappedEntity.cell),
		config,
		unitOwner
	)
	
	context["UnitsBC"]:addActiveUnit(domainEntity)
		
	return domainEntity
end

function module.buildNotPlacedUnit(
	context, 
	mappedEntity : unitDTO.unitDTO, 
	config, 
	party : string, 
	uniqueId : string, 
	unitOwner : string,
	attackerConfig
) : unitEntity.unitEntity
	if(not uniqueId) then uniqueId = httpService:GenerateGUID(false) end
	
	local attacker = attackerStructureEntity.new(
		mappedEntity.damage,
		mappedEntity.range,
		mappedEntity.attackSpeed,
		attackerConfig,
		context["ConstsBC"]["seed"]
	)
	
	local unit = unitEntity.newNotPlaced(
		uniqueId,
		mappedEntity.maxHealth,
		attacker,
		party,
		config,
		unitOwner
	)
	
	context["UnitsBC"]:addReservedUnit(unit)

	return unit
end

return module
