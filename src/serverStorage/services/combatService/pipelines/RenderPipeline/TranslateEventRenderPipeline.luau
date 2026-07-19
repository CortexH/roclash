local module = {}

local domain = game.ServerStorage.Server.services.combatService.modules.entityModule.domain

local mapApi = require(game.ServerStorage.Server.services.combatService.API.mapModule.MapModuleAPI)

local eventType = require(domain.events.EntityEvent)
local commandResponseType = require(domain.events.EntityCommandResponse)

local renderEventType = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

function translateUnitSpawned(event : eventType.unitSpawnedEvent, currentTime)
	local renderEvent : renderEventType.unitSpawn = {
		eventType = "UnitSpawn",
		time = event.time,
		data = {
			unitId = event.data.entityId,
			position = event.data.position,
			rotation = event.data.rotation,
			behavior = event.data.behavior,
			reason = event.data.reason
		}
	}

	return renderEvent
end

function translateUnitMovementEvent(event : eventType.unitMovementStartedEvent, currentTime)
	local renderEvent : renderEventType.unitMove = {
		eventType = "UnitMove",
		time = event.time,
		data = {
			unitId = event.data.unitId,
			origin = event.data.beginPosition,
			destination = event.data.finalPosition,
			movementTime = event.data.movementTime
		}
	}
	
	return renderEvent
end

function translateAttackStartedEvent()
	
end

function translateProjectLaunchedEvent(event : eventType.projectileLaunchedEvent, currentTime)
	
	local renderEvent : renderEventType.projectileLaunch = {
		eventType = "ProjectileLaunch",
		time = event.time,
		data = {
			projectileTypeId = 1, -- TODO:PROJECTILE colocar para poder inserir tipo de projetil
			targetType = event.data.targetType,
			timeToHit = event.data.timeToHit,
			source = event.data.source,
			targetPosition = event.data.targetPosition,
			targetId = event.data.targetId
		}
	}
	
	return renderEvent
	
end

function translateAttackImpactEvent()
	
end

function translateDamageAppliedEvent()
	
end

function translateUnitPlacementCommandResponse(event : commandResponseType.unitPlacementCommandResponse, currentTime)
	event.type = nil
	event.shouldRender = nil
	return event
end

function translateUnitDiedEvent(event : eventType.unitDiedEvent, currentTime)
	local renderEvent : renderEventType.unitDied = {
		eventType = "UnitDied",
		time = event.time,
		data = {
			unitId = event.data.targetId
		}
	}
	
	return renderEvent
end

function translateGameBeginEvent(event : eventType.unitDiedEvent, currentTime)
	return {
		eventType = "GameBeginEvent",
		time = event.time
	}
end

local enabledEvents = {
	["BeginGameEvent"] = translateGameBeginEvent,
	["UnitSpawnedEvent"] = translateUnitSpawned,
	["UnitMovementStartedEvent"] = translateUnitMovementEvent,
	["AttackStartedEvent"] = translateAttackStartedEvent,
	["ProjectileLaunchedEvent"] = translateProjectLaunchedEvent,
	["AttackImpactEvent"] = translateAttackImpactEvent,
	["DamageAppliedEvent"] = translateDamageAppliedEvent,
	["UnitDiedEvent"] = translateUnitDiedEvent,
	["UnitPlacementCommandResponse"] = translateUnitPlacementCommandResponse,
}

function module.translateEvent(event : eventType.defaultEventType, currentTime)
	return enabledEvents[event.eventType](event, currentTime)
end

return module
