local module = {}

-- Traduz UnitPlacementCommand em SpawnIntent. Sem validação (a validação fica no domínio).
function module.handle(command, context)
	local events = {}

	for _, v in command.data do
		table.insert(events, {
			eventType = "SpawnIntent",
			delay = 0,
			type = "EVENT",
			data = {
				entityId = v.entityId,
				position = v.position,
				behavior = v.behavior,
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
