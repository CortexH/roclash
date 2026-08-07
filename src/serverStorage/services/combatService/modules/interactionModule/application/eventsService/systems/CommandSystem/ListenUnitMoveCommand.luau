local module = {}

-- Traduz UnitMoveCommand em MoveIntent. Sem validação (a validação fica no domínio).
function module.handle(command, context)
	local events = {}

	for _, v in command.data do
		table.insert(events, {
			eventType = "MoveIntent",
			delay = 0,
			type = "EVENT",
			data = {
				unitId = v.unitId,
				targetCell = v.position,
				targetUnit = nil,
				reason = "COMMAND",
				origin = {
					type = "PLAYER",
					playerId = command.requesterId
				}
			},
			isValid = true
		})
	end

	return events
end

return module
