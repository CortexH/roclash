local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.unitLeftTowerRangeEvent, context)
	if event.isValid == false then return {} end	
	local tower = viewPort.getSelfBattleView(event.data.towerUnitId, context)
	local target = viewPort.getUnitBattleView(event.data.towerUnitId, event.data.targetUnitId, context)
	if not tower or not target then
		return {}
	end

	local delta = targetingService.getTowerTargetDelta(tower, context)

	if #delta.added == 0 and #delta.removed == 0 then
		return {}
	end

	local events = {}

	for _, id in delta.added do
		table.insert(events, eventService.targetAcquired(
			tower.id, id, 0))
	end

	for _, id in delta.removed do
		table.insert(events, eventService.targetLost(
			tower.id, id, 0))
	end

	return events
end

return module
