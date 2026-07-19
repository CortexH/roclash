local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

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
		table.insert(events, eventService.createAttackStartedEvent(0, event.data.unitId, targetId))
	end
		
	return events
end

return module
