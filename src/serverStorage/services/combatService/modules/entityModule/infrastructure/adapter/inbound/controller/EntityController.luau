local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local unitService = require(script.Parent.Parent.Parent.Parent.Parent.application.service.UnitService)
local entityMapper = require(script.Parent.Parent.Parent.inbound.controller.mapper.StructureEntityMapper)

local unitConfigMapper = require(script.Parent.Parent.Parent.inbound.controller.mapper.UnitConfigMapper)

local unitMapper = require(script.Parent.mapper.UnitMapper)

local unitConfig = require(domain.entity.UnitEntityAgg.UnitConfig)
local attackerConfig = require(domain.entity.UnitEntityAgg.AttackerUnitAgg.AttackerConfig)
local unitDataPort = require(domain.ports.gateways.UnitDataGatewayPort)

function module.loadEntities(context : {}, bruteData)
	
	local structures = bruteData["builds"]
	local npcs = bruteData["npcs"]
		
	for _, entity in structures do
		local config = unitConfigMapper.toStructureInbound(entity)
		local attackerData = unitDataPort.getStructureData(entity[1])
		
		local domainConfig = unitConfig.newStructureConfig(
			entity[1],
			unitDataPort.getStructureData(entity[1]).occupies
		)
		
		local attackerStructureConfig = nil
				
		if attackerData.attackerStructure then
			attackerStructureConfig = attackerConfig.new(
				attackerData.attackWindup,
				attackerData.targetConfig.targetMode,
				attackerData.targetConfig.impactShape,
				attackerData.targetConfig.deliveryType,
				attackerData.impactSize,
				attackerData.attackEndlag,
				nil,
				{
					quantity = attackerData.hitsConfig.quantity,
					interval = attackerData.hitsConfig.timeBetweenHit
				},
				attackerData.projectileSpeed,
				attackerData.damageType,
				attackerData.targetConfig.maxTargets
			)
		end
		
		local mappedEntity = entityMapper.toStructureInbound(entity)
		
		local domainEntity = unitService.buildNotPlacedUnit(
			context,
			mappedEntity, 
			domainConfig, 
			"DEFENSE",
			nil,
			context["IdentityBC"].defenderPlayerId,
			attackerStructureConfig
		);
		
		context["SnapshotBC"]:addSnapshotUnit(domainEntity.uniqueId, mappedEntity.cell, mappedEntity.facing)
	end
	
	for _, entity in npcs do
		local config = unitConfigMapper.toNpcInbound(entity)
		local swordData = unitDataPort.getSwordData(entity[10])
		
		local attackerNpcConfig = attackerConfig.new(
			swordData.attackWindup,
			swordData.targetConfig.targetMode,
			swordData.targetConfig.impactShape,
			swordData.targetConfig.deliveryType,
			swordData.impactSize,
			swordData.attackEndlag,
			nil,
			{
				quantity = swordData.hitsConfig.quantity,
				interval = swordData.hitsConfig.timeBetweenHit
			},
			swordData.attackSpeed,
			swordData.damageType
		)
		
		local domainConfig = unitConfig.newNpcConfig(
			config.equipment,
			config.sword,
			config.behavior,
			config.aggroRange,
			config.damageType,
			config.walkSpeed
		)
		
		local mappedEntity = entityMapper.toNpcInbound(entity)
		
		local domainEntity = unitService.buildNotPlacedUnit(
			context,
			mappedEntity, 
			domainConfig, 
			"DEFENSE",
			nil,
			context["IdentityBC"].defenderPlayerId,
			attackerNpcConfig
		);
		context["SnapshotBC"]:addSnapshotUnit(domainEntity.uniqueId, mappedEntity.cell, mappedEntity.facing)

	end
	
	return context
end

function module.loadNotPlacedUnits(context : {}, attackerData)
	local attackerUserId = context["IdentityBC"]["attackerPlayerId"]
	
	local data = {
		["byList"] = {},
		["byId"] = {}
	}
	
	for _, entity in attackerData["soldiers"]["byId"] do
		local dto = entityMapper.toNotPlacedNpcInbound(entity);
		local config = unitConfigMapper.toNotPlacedNpcInbound(entity)
			
		local swordData = unitDataPort.getSwordData(entity.sword)

		local attackerNpcConfig = attackerConfig.new(
			swordData.attackWindup,
			swordData.targetConfig.targetMode,
			swordData.targetConfig.impactShape,
			swordData.targetConfig.deliveryType,
			swordData.impactSize,
			swordData.attackEndlag,
			nil,
			{
				quantity = swordData.hitsConfig.quantity,
				interval = swordData.hitsConfig.timeBetweenHit
			},
			swordData.attackSpeed,
			swordData.damageType
		)
		
		
		
		local domainConfig = unitConfig.newNpcConfig(
			config.equipment,
			config.sword,
			config.behavior,
			config.aggroRange,
			config.damageType,
			config.walkSpeed
		)
		
		local domainEntity = unitService.buildNotPlacedUnit(
			context,
			dto,
			domainConfig, 
			"ATTACKER", 
			entity.uniqueId,
			context["IdentityBC"].attackerPlayerId,
			attackerNpcConfig
		);
		
		context["UnitsBC"]:addReservedUnit(domainEntity)
	end
		
	return data
end

return module
