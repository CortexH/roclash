local module = {}

local combatClientEvents = require(script.Parent.Parent.Parent.Parent.Parent.Parent.events.combat.CombatClientEvents)

local damageIndicatorRegistry = require(script.Parent.Parent.Parent.Parent.Parent.Parent.state.registry.DamageIndicatorRegistry)
local unitViewRegistry = require(script.Parent.Parent.Parent.Parent.Parent.Parent.state.registry.UnitViewRegistry)

local damageIndicatorRender = require(script.Parent.Parent.Parent.Parent.Parent.Parent.render.effects.DamageIndicatorRender)

-- Aplica o evento interno no runtime: resolve a unit através de UnitBattleView
-- (UnitViewRegistry) e registra o estado necessário para a renderização.
function module.apply(event : combatClientEvents.damageIndicatorCreated)
	local unitView = unitViewRegistry.get(event.data.unitId)
	if not unitView then return end

	local indicator = damageIndicatorRegistry.create(event.data.unitId, event.data.amount, event.time)
	damageIndicatorRegistry.register(indicator.id, indicator)
	damageIndicatorRender.spawn(indicator.id)
end

return module
