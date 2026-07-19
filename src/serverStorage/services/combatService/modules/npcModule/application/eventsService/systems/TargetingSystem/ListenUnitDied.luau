local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.unitDiedEvent, context)
	if event.isValid == false then return {} end	

	local deadUnitId = event.data.targetId
	local allBrains = brainPort.getAllNpcsBrainsWithId(context)
	local events = {}

	for npcId, brain in pairs(allBrains) do
		local targeting = brain:getTargeting()
		
		if targeting:isActiveTarget(deadUnitId) then
			local tower = viewPort.getSelfBattleView(npcId, context)
			if tower then
				local delta = targetingService.getTowerTargetDelta(tower, context)

				for _, id in delta.removed do
					table.insert(events, eventService.targetLost(0, npcId, id))
				end
				
				for _, id in delta.added do
					table.insert(events, eventService.targetAcquired(0, npcId, id))
				end
			end
		end
	end
	
	return events
end

return module
