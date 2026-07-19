local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local towerDomainService = require(domain.domainService.TowerDomainService)
local mathService = require(domain.domainService.MathService)

local attackerConfig = require(domain.entity.UnitEntityAgg.AttackerUnitAgg.AttackerConfig)

function handleProjectileTypeAttack(
	attacker : unitEntity.unitEntity, 
	target : unitEntity.unitEntity, 
	config : attackerConfig.attackerConfig, 
	currentTime
)
	
	local generatedEvents = {}
	local actualDelay = config:getWindupTime()

	for i = 1, config:getHitConfig().quantity do
		actualDelay += config:getHitConfig().interval
		
		-- TODO: dar uma lida nisso aqui pra ajustar o activeMovement
		-- (agora o getPosition pode pegar o active movement caso ele existir)
		local targetPos = target:getPosition():getCurrentPosition()
		
		if target:getPosition():getActiveMovement() ~= nil then
			local endPos = target:getPosition():getActiveMovement()
				:getPositionAtTime(currentTime + actualDelay)

			targetPos = target:getPosition():getActiveMovement()
				:getPositionAtTime(currentTime + actualDelay + getProjectileTravelTime(
					attacker:getPosition():getCurrentPosition(),
					endPos,
					config:getAttackSpeed()
					))
		end
		
		if config:getImpactShape() == "POINT" then
			table.insert(generatedEvents, generateProjectileEventSingle(
				target, actualDelay, attacker, i, currentTime + actualDelay
				))
		else
			
			table.insert(generatedEvents, generateProjectileEventAOE(
				target, actualDelay, attacker, targetPos, i, currentTime + actualDelay
				))
			
		end

	end
	return generatedEvents
end

function handleInstantTypeAttack(attacker, target, config)
	warn("ATTACK TYPE 'INSTANT' NOT IMPLEMENTED")
	return {}
end


function generateProjectileEventSingle(target, delay, attacker, impactNumber, ct)
	local event : eventType.projectileLaunchedEvent = {
		delay = delay,
		eventType = "ProjectileLaunchedEvent",
		type = "EVENT",
		data = {
			targetType = "UNIT",
			targetId = target:getId(),
			projectileSpeed = attacker:getAttacker():getAttackerConfig():getAttackSpeed(),
			source = attacker:getId(),
			timeToHit = mathService.getTravelTime(
				attacker:getPosition():getCurrentPosition(ct), 
				target:getPosition():getCurrentPosition(ct), 
				attacker:getAttacker():getAttackerConfig():getAttackSpeed())
		}
	}
	return event
end

function generateProjectileEventAOE(target, delay, attacker, position, impactNumber, ct)
	local event : eventType.projectileLaunchedEvent = {
		delay = delay,
		eventType = "ProjectileLaunchedEvent",
		type = "EVENT",
		data = {
			targetType = "POSITION",
			targetPosition = position,
			targetId = target:getId(),
			projectileSpeed = attacker:getAttacker():getAttackerConfig():getAttackSpeed(),
			source = attacker:getId(),
			timeToHit = mathService.getTravelTime(
				attacker:getPosition():getCurrentPosition(ct), 
				target:getPosition():getCurrentPosition(ct), 
				attacker:getAttacker():getAttackerConfig():getAttackSpeed())
		}
	}
	return event
end

local mathService = require(domain.domainService.MathService)

function getProjectileTravelTime(startPos, endPos, projectileSpeed)
	return mathService.getTravelTime(startPos, endPos, projectileSpeed)
end

local dispatcher = {
	["PROJECTILE"] = handleProjectileTypeAttack,
	["MELEE"] = function() return {} end,
	["INSTANT"] = handleInstantTypeAttack
}

function module.generate(
	event : eventType.attackStartedEvent, context
)
	local unitsBC = context["UnitsBC"]

	local attacker : unitEntity.unitEntity = unitsBC:getActiveUnitById(event.data.attackerId)
	local config = attacker:getAttacker():getAttackerConfig()

	local target = unitsBC:getActiveUnitById(event.data.targetId)

	return dispatcher[config:getDeliveryType()](attacker, target, config, context["TimeBC"].currentTime)
end

return module
