local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)
local attackIntentTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.intents.AttackIntentEvent)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.cooldownReadyEvent, context)
	if event.isValid == false then return {} end

	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	if not brain then return {} end

	local activeTargets = brain:getTargeting():getActiveTargetsList()
	if #activeTargets == 0 then return {} end

	local events = {}
	
	--local self = viewPort.getSelfBattleView(event.data.unitId, context)
	--if not self.canAttack then return {} end
	
	for _, targetId in ipairs(activeTargets) do
		-- Dispara um AttackIntent em vez de um AttackStarted direto
		local intent : attackIntentTypes.AttackIntent = {
			delay = 0,
			eventType = "AttackIntent",
			type = "EVENT",
			data = {
				source = event.data.unitId,
				target = {
					targetType = "UNIT",
					id = targetId,
					position = {x = 0, y = 0} -- O sistema de validação/applier deve tratar a posição real se necessário
				},
				origin = {
					type = "SYSTEM",
					playerId = nil
				}
			},
			isValid = true
		}
		table.insert(events, intent)
	end
		
	return events
end

return module

