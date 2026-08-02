local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local intentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AggroIntentEvent)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.attackResolvedEvent, context)
	
	-- Só re-dispara o aggro search se o alvo atual não for mais válido.
	-- Se a unidade ainda está aggroando um alvo vivo, mantém o aggro atual
	-- (evita o ciclo de re-aggro que gera avalanches de UnitAggroStartedEvent).
	local brain = brainPort.getNpcBrain(event.data.attackerId, context)
	if brain and brain:getAggro() then
		local currentAggro = brain:getAggro():getCurrentAggro()
		if currentAggro then
			local aggroView = viewPort.getUnitBattleView(event.data.attackerId, currentAggro, context)
			if aggroView and aggroView.isAlive then
				return {}
			end
		end
	end

    return {{
        ["delay"] = 0,
        ["eventType"] = "UnitAggroSearchEvent",
        ["type"] = "EVENT",
        ["data"] = {
            ["aggroingUnitId"] = event.data.attackerId,
            --["aggroVersion"] = string,
        },
        ["isValid"] = true
    }}

end

return module
