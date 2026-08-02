local module = {}

local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

-- Tempo (em segundos) que a unit morta permanece no mundo antes da remoção real.
local REMOVAL_DELAY = 5

-- Observa a morte da unit e agenda a remoção real através de um evento interno
-- com delay, processado de forma determinística pela fila de eventos.
function module.handle(event : clientEvents.unitDied)
	return {
		{
			eventType = "UnitRemoved",
			delay = REMOVAL_DELAY,
			data = {
				unitId = event.data.unitId
			}
		}
	}
end

return module
