local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

local viewRegistry = require(root.state.registry.UnitViewRegistry)
local stateCache = require(root.state.cache.UnitStateCache)
local definition = require(root.state.cache.UnitDefinitionCache)

local mapUtils = require(game.ReplicatedStorage.Shared.combat.shared.utils.PlayerMapUtils)
local mapConsts = require(root.consts.MapConsts)

local render = require(root.render.unit.UnitLifecycleRender)

function module.apply(event : clientEvents.unitSpawn)
	
	local unitDef = definition.get(event.data.unitId)
	local unitState = updateState(event, stateCache.get(event.data.unitId))
	
	local view = viewRegistry.create(
		unitDef, unitState
	)
	
	viewRegistry.register(event.data.unitId, view)
	stateCache.register(event.data.unitId, unitState)
	
	-- TODO: ajustar o modelo do npc com a espada e etc.
	
	render.spawn(event.data.unitId)
end

function updateState(event : clientEvents.unitSpawn, state : (typeof(stateCache.get(""))))
		
	state.placed.isPlaced = true
	state.placed.cell = event.data.position
	state.placed.rotation = event.data.rotation
	state.placed.position = mapUtils.getPositionByCell(event.data.position, mapConsts)

	return state
	
end

return module
