local module = {}

local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

local damageIndicatorRegistry = require(script.Parent.Parent.Parent.Parent.Parent.Parent.state.DamageIndicatorRegistry)
local unitViewRegistry = require(script.Parent.Parent.Parent.Parent.Parent.Parent.state.UnitViewRegistry)

local damageIndicatorRender = require(script.Parent.Parent.Parent.Parent.Parent.Parent.render.effects.DamageIndicatorRender)

-- Aplica o evento interno no runtime: resolve a unit através de UnitBattleView
-- (UnitViewRegistry) e registra o estado necessário para a renderização.
function module.apply(event : clientEvents.damageIndicatorCreated)
	local unitView = unitViewRegistry.get(event.data.unitId)
	if not unitView then return end

	local indicator = damageIndicatorRegistry.create(event.data.unitId, event.data.amount, event.time)
	damageIndicatorRegistry.register(indicator.id, indicator)
	damageIndicatorRender.spawn(indicator.id)
end

return module
