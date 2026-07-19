local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local selfView = require(domain.entity.SelfBattleView)
local unitView = require(domain.entity.UnitBattleView)

local port = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local mapAPI = require(game.ServerStorage.Server.services.combatService.API.mapModule.MapModuleAPI)

local unitEntity = require(game.ServerStorage.Server.services.combatService.modules.entityModule.domain.entity.UnitEntity)

port.getSelfBattleView = function(selfId, context)
	local ct = context["TimeBC"].currentTime
	local unit : unitEntity.unitEntity = context["UnitsBC"]:getUnit(selfId)
		
	local view : selfView.SelfBattleView = {
		id = selfId,
		
		health = unit:getHealth(),
		maxHealth = unit:getMaxHealth(),
		
		healthPercent = (unit:getHealth() / unit:getMaxHealth()),
		
		isAlive = not unit:isDead(),
		isPlaced = unit:isPlaced(),
		
		party = unit:getParty(),
		
		isLowHealth = unit:isLowHealth(),
		dangerLevel = 1
	}
	
	if view.isPlaced then
		
		view.currentPosition = unit:getPosition():getCurrentPosition(ct)
		view.currentCell = mapAPI.getCellByWorldPosition(unit:getPosition():getCurrentPosition(ct))

		view.lastUpdatedCell = unit:getCurrentCell()
		view.lastUpdatedPosition = unit:getPosition():getCurrentPosition()
		
		if unit:getPosition():getActiveMovement() then
			view.hasActiveMovement = unit:getPosition():getActiveMovement():isExpired(ct)
		else
			view.hasActiveMovement = false
		end		
	end
	
	if unit:getAttacker() then
		view.damage = unit:getAttacker():getDamage()
		view.range = unit:getAttacker():getRange()
		view.attackSpeed = unit:getAttacker():getAttackSpeed()
		
		view.aggroRange = unit:getNpcConfig():getAggroRange()
		view.aggroBehavior = unit:getNpcConfig():getBehavior()
		
		local cd = ((unit:getAttacker():getLastAttackTime() or 0) + unit:getAttacker():getAttackCooldownTime()) - context["TimeBC"].currentTime
		view.canAttack = cd + unit:getAttacker():getAttackerConfig():getTotalAttackTime() <= 0
		if cd < 0 then cd = 0 end
		view.cooldownRemaining = cd
		
		view.maxTargets = unit:getAttacker():getAttackerConfig():getMaxTargets()
		view.targetingPriority = "NEAREST" -- TODO: colocar algo para permitir adicionar mais targetingBehaviors
		view.targetingBehavior = ""
	end
		
	return view
end

port.getUnitBattleView = function(selfId, unitId, context)
	local ct = context["TimeBC"].currentTime

	local unit : unitEntity.unitEntity = context["UnitsBC"]:getUnit(unitId)
	local self : unitEntity.unitEntity = context["UnitsBC"]:getUnit(selfId)

	local view : unitView.UnitBattleView = {
		id = unitId,

		health = unit:getHealth(),
		maxHealth = unit:getMaxHealth(),
		
		isAlive = not unit:isDead(),
		isPlaced = unit:isPlaced(),

		party = unit:getParty(),
		isEnemy = unit:getParty() ~= self:getParty(),
				
		unitType = unit:getNpcConfig():getUnitType(),
		blockingType = unit:getNpcConfig():getBlockCellType(),
		
		threatLevel = 1,
		priority = 1,
	}
	
	if view.isPlaced then
		view.currentPosition = unit:getPosition():getCurrentPosition(ct)
		view.currentCell = mapAPI.getCellByWorldPosition(unit:getPosition():getCurrentPosition(ct))
		
		view.distanceToSelf = self:getPosition():getCurrentPosition(ct)
			:distanceTo(unit:getPosition():getCurrentPosition(ct))
		
		view.inRange = self:isInRange(unit:getPosition():getCurrentPosition(ct))
	end
	
	return view
	
end

return module
