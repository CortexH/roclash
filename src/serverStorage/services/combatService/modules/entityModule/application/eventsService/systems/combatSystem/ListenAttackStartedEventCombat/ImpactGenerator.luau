local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.Parent.domain
local eventType = require(domain.events.EntityEvent)

local unitEntity = require(domain.entity.UnitEntity)
local attackerConfig = require(domain.entity.UnitEntityAgg.AttackerUnitAgg.AttackerConfig)

function module.generate(
	event : eventType.attackStartedEvent, context
)
	local unitsBC = context["UnitsBC"]

	local attacker : unitEntity.unitEntity =
		unitsBC:getActiveUnitById(event.data.attackerId)

	local target : unitEntity.unitEntity =
		unitsBC:getActiveUnitById(event.data.targetId)

	local config = attacker:getAttacker():getAttackerConfig()
	
	if config:getDeliveryType() == "MELEE" then
		return handleMeleeImpactEvent(
			attacker,
			target,
			config,
			context["TimeBC"].currentTime
		)
	elseif config:getDeliveryType() == "PROJECTILE" then
		return handleProjectileImpactEvent(
			attacker,
			target,
			config,
			context["TimeBC"].currentTime
		)		
	end
end


function handleProjectileImpactEvent(
	attacker : unitEntity.unitEntity,
	target : unitEntity.unitEntity,
	config : attackerConfig.attackerConfig,
	currentTime
)

	local generatedEvents = {}

	local attackerPos = attacker:getPosition():getCurrentPosition()

	local windup = config:getWindupTime()
	local interval = config:getHitConfig().interval
	local quantity = config:getHitConfig().quantity

	local actualDelay = windup

	for i = 1, quantity do
		if i > 1 then
			actualDelay += interval
		end

		local impactDelay = actualDelay

		local predictedTargetPos = target:getPosition():getCurrentPosition()
		local distanceToTarget

		local movement = target:getPosition():getActiveMovement()
				
		if movement ~= nil then

			-- posição do alvo no momento do disparo
			local targetPosAtFire =
				movement:getPositionAtTime(currentTime + actualDelay)

			distanceToTarget = attackerPos:distanceTo(targetPosAtFire)

			local projectileTime =
				config:getAttackProjectileTravelTime(distanceToTarget)

			impactDelay += projectileTime
			
			-- posição prevista no impacto
			
			predictedTargetPos =
				movement:getPositionAtTime(currentTime + impactDelay)
		else
			distanceToTarget = attackerPos:distanceTo(predictedTargetPos)
			local projectileTime =
				config:getAttackProjectileTravelTime(distanceToTarget)
			impactDelay += projectileTime
		end

		if config:getImpactShape() == "POINT" then

			table.insert(
				generatedEvents,
				generateImpactEventSingle(
					target,
					impactDelay,
					attacker,
					i
				)
			)
		else
			table.insert(
				generatedEvents,
				generateImpactEventAOE(
					target,
					impactDelay,
					attacker,
					predictedTargetPos,
					i
				)
			)

		end

	end

	return generatedEvents

end

-- TODO: implementar outros tipos de hits
function handleMeleeImpactEvent(
	attacker : unitEntity.unitEntity,
	target : unitEntity.unitEntity,
	config : attackerConfig.attackerConfig,
	currentTime
)
	
	local windup = config:getWindupTime()
	local endlag = config:getEndlag()
	
	if config:getImpactShape() == "POINT" then
		return {generateImpactEventSingle(
			target,
			windup,
			attacker,
			1
		)}
	elseif config:getImpactShape() == "RADIUS" then
		return {}
	end
	
end

function generateImpactEventSingle(target, delay, attacker, impactNumber)

	local event : eventType.attackImpactEvent = {
		delay = delay,
		eventType = "AttackImpactEvent",
		type = "EVENT",
		data = {
			impactType = "UNIT",
			impactUnitId = target:getId(),
			sourceUnitId = attacker:getId(),
			impactNumber = impactNumber
		}
	}

	return event

end


function generateImpactEventAOE(target, delay, attacker, position, impactNumber)

	local event : eventType.attackImpactEvent = {
		delay = delay,
		eventType = "AttackImpactEvent",
		type = "EVENT",
		data = {
			impactType = "POSITION",
			impactPosition = position,
			sourceUnitId = attacker:getId(),
			impactUnitId = target:getId(),
			impactNumber = impactNumber
		}
	}

	return event

end

return module