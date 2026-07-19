local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local aggroService = require(domain.service.AggroService)
local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)


function module.handle(event : combatEventTypes.targetAcquiredEvent, context)
	if event.isValid == false then return {} end

	local selfView = viewPort.getSelfBattleView(event.data.unitId, context)
	if not selfView then return {} end
	if not selfView.canAttack then return {} end

	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	if not brain then return {} end
	
	local self = viewPort.getSelfBattleView(event.data.unitId, context)
	if not self.canAttack then return {} end
	
	if not brain:getTargeting():isActiveTarget(event.data.targetId) then return {} end	
	
	return { eventService.createAttackStartedEvent(0, event.data.unitId, event.data.targetId) }
end

return module
