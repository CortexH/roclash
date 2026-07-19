local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.apply(event : combatEventTypes.unitLeftTowerRangeEvent, context)
	if event.isValid == false then return {} end	
	local tower = viewPort.getSelfBattleView(event.data.towerUnitId, context)
	local target = viewPort.getUnitBattleView(event.data.towerUnitId, event.data.targetUnitId, context)
	if not tower or not target then
		return {}
	end

	local brain = brainPort.getNpcBrain(event.data.towerUnitId, context)
	local targeting = brain:getTargeting()

	targeting:removePossibleTarget(event.data.targetUnitId)
	
	return {}
end

return module
