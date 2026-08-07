local module = {}

-- Gera UnitPlacementCommandResponse a partir do intentResponse, se origin for player.
function module.handle(event, context)
	local origin = event.data.origin
	if not origin or origin.type ~= "PLAYER" then return {} end

	local accepted = event.eventType == "SpawnIntentAccepted"

	local data = {
		commandResponseType = accepted and "SUCCESS" or "REJECT",
		entityId = event.data.entityId,
		reason = accepted and nil or event.data.reason
	}

	if accepted then
		data.success = {
			entityId = event.data.entityId,
			position = event.data.position,
			behavior = event.data.behavior
		}
	end

	return {{
		eventType = "UnitPlacementCommandResponse",
		delay = 0,
		type = "COMMAND_RESPONSE",
		shouldRender = true,
		data = data
	}}
end

return module
