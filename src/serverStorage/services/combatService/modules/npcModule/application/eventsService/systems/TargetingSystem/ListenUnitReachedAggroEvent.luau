local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local pathService = require(domain.service.PathService)
local mapPort = require(domain.ports.MapPort)

function module.handle(event : combatEventTypes.unitReachedAggroEvent, context)
	if event.isValid == false then return {} end
	
	local unit = viewPort.getSelfBattleView(event.data.unitId, context)
	if not unit then return {} end
	if not unit.isAlive then return {} end
	local brain = brainPort.getNpcBrain(event.data.unitId, context)
	
	local aggroId = brain:getAggro():getCurrentAggro()
	if not aggroId then return {} end
	
	local aggroView = viewPort.getUnitBattleView(unit.id, aggroId, context)
	
	if not aggroView.isAlive then return {} end
	if not aggroView.inRange then return {} end
	
	return { eventService.targetAcquired(
		0,
		event.data.unitId,
		aggroId
		)}
end

return module
