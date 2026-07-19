local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.CombatEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

function module.handle(event : combatEventTypes.unitDiedEvent, context)
	if event.isValid == false then return {} end
	local generatedEvents = {}
	local allBrains = brainPort.getAllNpcsBrainsWithId(context)
	for unitId, brain in pairs(allBrains) do
		if not brain:getAggro() then continue end
		local currentAggro = brain:getAggro():getCurrentAggro()
		if currentAggro == event.data.targetId then
			table.insert(generatedEvents, eventService.createUnitAggroStoppedEvent(
				0,
				unitId,
				event.data.targetId
				))
		end
	end
	return generatedEvents
end

return module
