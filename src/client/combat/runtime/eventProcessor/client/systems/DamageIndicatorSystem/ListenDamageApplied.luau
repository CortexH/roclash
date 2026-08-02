local module = {}

local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)
local combatClientEvents = require(script.Parent.Parent.Parent.Parent.Parent.Parent.events.combat.CombatClientEvents)

-- Observa o fato de que uma unit recebeu dano e decide que um
-- Damage Indicator deve ser criado. Não aplica efeitos no runtime.
function module.handle(event : clientEvents.damageApplied) : { combatClientEvents.damageIndicatorCreated }
	return {
		{
			eventType = "DamageIndicatorCreated",
			time = event.time,
			data = {
				unitId = event.data.unitId,
				amount = event.data.damage
			}
		}
	}
end

return module
