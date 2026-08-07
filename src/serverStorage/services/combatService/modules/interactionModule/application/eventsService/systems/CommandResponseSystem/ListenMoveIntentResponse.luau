local module = {}

-- Gera UnitMoveCommandResponse a partir do intentResponse, se origin for player.
function module.handle(event, context)
	local origin = event.data.origin
	if not origin or origin.type ~= "PLAYER" then return {} end

	local accepted = event.eventType == "MoveIntentAccepted"

	return {{
		eventType = "UnitMoveCommandResponse",
		delay = 0,
		type = "COMMAND_RESPONSE",
		shouldRender = true,
		data = {
			commandResponseType = accepted and "SUCCESS" or "REJECT",
			unitId = event.data.unitId,
			reason = accepted and nil or event.data.reason
		}
	}}
end

return module
