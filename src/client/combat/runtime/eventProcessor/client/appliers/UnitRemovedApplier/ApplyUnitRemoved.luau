local module = {}

local combatClientEvents = require(script.Parent.Parent.Parent.Parent.Parent.Parent.events.combat.CombatClientEvents)

local render = require(script.Parent.Parent.Parent.Parent.Parent.Parent.render.unit.UnitLifecycleRender)

-- Remoção real: destrói o model e limpa o estado do client.
function module.apply(event : combatClientEvents.unitRemoved)
	render.despawn(event.data.unitId)
end

return module
