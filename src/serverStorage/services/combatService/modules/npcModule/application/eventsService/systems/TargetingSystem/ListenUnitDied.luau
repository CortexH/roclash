local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)
local mapPort = require(domain.ports.MapPort)

function module.handle(event : combatEventTypes.unitDiedEvent, context)
	if event.isValid == false then return {} end	

	local deadUnitId = event.data.targetId
	local allBrains = brainPort.getAllNpcsBrainsWithId(context)
	local events = {}

	for npcId, brain in pairs(allBrains) do
		local targeting = brain:getTargeting()
		
		if targeting:isActiveTarget(deadUnitId) then
			local selfView = viewPort.getSelfBattleView(npcId, context)
			if selfView then
				local delta = targetingService.getTowerTargetDelta(selfView, context)

				for _, id in delta.removed do
					table.insert(events, eventService.targetLost(0, npcId, id))
				end
				
				for _, id in delta.added do
					table.insert(events, eventService.targetAcquired(0, npcId, id))
				end

				-- Retoma o objetivo original: o alvo que morreu era um obstáculo
				-- (ex: Wall bloqueando o caminho) e a unit ainda possui um aggro
				-- (ex: Tower) vivo. Re-planeja a movimentação até ele.
				local aggro = brain:getAggro()
				if aggro then
					local currentAggro = aggro:getCurrentAggro()
					if currentAggro and currentAggro ~= deadUnitId then
						local aggroView = viewPort.getUnitBattleView(npcId, currentAggro, context)
						if aggroView and aggroView.isAlive then
							local hasWall = mapPort.hasWallToward(selfView.currentCell, aggroView.currentCell, context)

							if not hasWall and aggroView.inRange then
								-- já está em range e sem bloqueio: ataca o objetivo original
								table.insert(events, eventService.targetAcquired(0, npcId, currentAggro))
							else
								table.insert(events, eventService.createMovementIntent(
									0, npcId, nil, currentAggro, "PATH_BLOCKED"
								))
							end
						end
					end
				end
			end
		end
	end
	
	return events
end

return module
