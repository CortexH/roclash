local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.apply(event : combatEventTypes.unitEnteredTowerRangeEvent, context)
	if event.isValid == false then return {} end	

	local tower = viewPort.getSelfBattleView(event.data.towerUnitId, context)
	local target = viewPort.getUnitBattleView(event.data.towerUnitId, event.data.targetUnitId, context)
	local brain = brainPort.getNpcBrain(event.data.towerUnitId, context)
		
	if tower.party == target.party then return end
	
	brain:getTargeting():addPossibleTarget(target.id)
	
end

return module
