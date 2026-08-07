local module = {}

local domain = script.Parent.Parent.Parent.Parent.Parent.domain

local targetingService = require(domain.service.TargetingService)
local eventService = require(domain.service.NpcEventFactory)

local combatEventTypes = require(game.ServerStorage.Server.services.combatService.shared.eventTypes.AggroEvents)

local viewPort = require(domain.ports.BattleViewPort)
local brainPort = require(domain.ports.NpcBrainPort)

local pathService = require(domain.service.PathService)
local mapPort = require(domain.ports.MapPort)

function module.handle(event : combatEventTypes.UnitAggroStartedEvent, context)
	if event.isValid == false then return {} end

	-- TODO: Adicionar validação das versões de movimento (aggroingUnitMovementVersion e aggroedUnitMovementVersion)
	-- para garantir que o evento não processará versões obsoletas do movimento.

	return {eventService.createMoveIntent(
		0, event.data.aggroingUnitId, nil, event.data.aggroedUnitId, "AGGRO"
		)}
end

return module

