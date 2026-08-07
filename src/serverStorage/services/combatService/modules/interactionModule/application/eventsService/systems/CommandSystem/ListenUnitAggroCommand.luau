local module = {}

-- Traduz UnitAggroCommand em AggroIntent. Sem validação (a validação fica no domínio).
function module.handle(command, context)
	return {{
		eventType = "AggroIntent",
		delay = 0,
		type = "EVENT",
		data = {
			source = command.data.unitId,
			target = command.data.targetId,
			origin = {
				type = "PLAYER",
				playerId = command.requesterId
			},
			policy = "COMMAND"
		},
		isValid = true
	}}
end

return module
