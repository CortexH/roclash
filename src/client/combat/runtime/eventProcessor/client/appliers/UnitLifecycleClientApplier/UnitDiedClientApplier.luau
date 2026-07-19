local module = {}

local states = script.Parent.Parent.Parent.Parent.Parent.Parent.state
local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

local viewRegistry = require(states.UnitViewRegistry)
local stateCache = require(states.UnitStateCache)
local definition = require(states.UnitDefinitionCache)

local render = require(script.Parent.Parent.Parent.Parent.Parent.Parent.render.unit.UnitLifecycleRender)

function module.apply(event : clientEvents.unitDied)
	local state = stateCache.get(event.data.unitId)
	
	state.placed = false
	state.health = 0
	state.maxHealth = 0
	state.owner = nil
		
	render.despawn(event.data.unitId)
	
end

return module
