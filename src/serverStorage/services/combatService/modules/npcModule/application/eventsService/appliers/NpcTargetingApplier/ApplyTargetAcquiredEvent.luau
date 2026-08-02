local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.apply(event : combatEventTypes.targetAcquiredEvent, context)
	if event.isValid == false then return {} end

	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	if not brain then return {} end

	local targeting = brain:getTargeting()
	local newTarget = event.data.targetId

	-- O target é a unit que está sendo atacada AGORA. Quando a unit adquire um
	-- novo alvo (via unitReachedAggro/verifyAggroReached) e o targeting está com
	-- o slot cheio, o novo alvo substitui os alvos ativos que não são ele mesmo.
	-- Isso evita que o alvo antigo ocupe o slot e impeça o novo TargetAcquired de
	-- gerar AttackIntent (bug de troca de alvo durante o ataque). O target pode
	-- ser diferente do aggro (aggro = desejo, target = ataque atual).
	if targeting:getActiveTargetSpace() <= 0 then
		for _, activeId in targeting:getActiveTargetsList() do
			if activeId ~= newTarget then
				targeting:removeActiveTarget(activeId)
			end
		end
	end

	targeting:addActiveTarget(newTarget)

	return {}
end

return module
