local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local attackIntentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AttackIntentEvent)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)


function module.handle(event : combatEventTypes.targetAcquiredEvent, context)
	if event.isValid == false then return {} end

	local selfView = viewPort.getSelfBattleView(event.data.unitId, context)
	if not selfView then return {} end
	if not selfView.canAttack then return {} end

	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	if not brain then return {} end
	
	if not brain:getTargeting():isActiveTarget(event.data.targetId) then return {} end
	
	-- Dispara um AttackIntent em vez de um AttackStarted direto
	local intent : attackIntentTypes.AttackIntent = {
		delay = 0,
		eventType = "AttackIntent",
		type = "EVENT",
		data = {
			source = event.data.unitId,
			target = {
				targetType = "UNIT",
				id = event.data.targetId,
				position = {x = 0, y = 0}
			},
			origin = {
				type = "SYSTEM",
				playerId = nil
			}
		},
		isValid = true
	}

	return { intent }
end

return module

