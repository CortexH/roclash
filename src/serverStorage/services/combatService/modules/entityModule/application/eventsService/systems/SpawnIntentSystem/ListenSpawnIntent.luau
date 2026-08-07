local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local unitPlacementService = require(domain.domainService.UnitPlacementService)
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.SpawnIntentEvent)

-- Valida o SpawnIntent de acordo com o domínio e produz SpawnIntentAccepted/Rejected.
function module.handle(event : intentTypes.SpawnIntent, context)
	if event.isValid == false then return {} end

	local data = event.data

	if not data.entityId then return {reject(event, "MISSING_ENTITY_ID")} end
	if not data.position then return {reject(event, "MISSING_POSITION")} end
	if not data.behavior then return {reject(event, "MISSING_BEHAVIOR")} end
	if not data.position.x or not data.position.y
		or type(data.position.x) ~= "number" or type(data.position.y) ~= "number" then
		return {reject(event, "INVALID_POSITION")}
	end

	local requesterId = data.origin and data.origin.playerId

	local placementSuc, unitPlaceMsg = unitPlacementService.validateUnitPlacement(
		data.position,
		0,
		requesterId,
		data.behavior,
		data.entityId,
		context
	)

	if not placementSuc then return {reject(event, unitPlaceMsg)} end

	return {accept(event)}
end

function accept(event)
	return {
		eventType = "SpawnIntentAccepted",
		delay = 0,
		type = "EVENT",
		data = {
			entityId = event.data.entityId,
			position = event.data.position,
			behavior = event.data.behavior,
			origin = event.data.origin
		},
		isValid = true
	}
end

function reject(event, reason)
	return {
		eventType = "SpawnIntentRejected",
		delay = 0,
		type = "EVENT",
		data = {
			entityId = event.data.entityId,
			position = event.data.position,
			behavior = event.data.behavior,
			reason = reason,
			origin = event.data.origin
		},
		isValid = true
	}
end

return module
