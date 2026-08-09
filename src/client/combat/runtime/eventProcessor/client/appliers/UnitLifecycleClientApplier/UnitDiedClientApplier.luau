local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local states = root.state
local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

local viewRegistry = require(states.registry.UnitViewRegistry)
local stateCache = require(states.cache.UnitStateCache)
local definition = require(states.cache.UnitDefinitionCache)

local render = require(root.render.unit.UnitLifecycleRender)
local moveInput = require(root.input.MoveUnitInput)
local attackInput = require(root.input.AttackUnitInput)

function module.apply(event : clientEvents.unitDied)
	local unitId = event.data.unitId
	local state = stateCache.get(unitId)
	
	state.placed = false
	state.health = 0
	state.maxHealth = 0
	state.owner = nil
		
	render.kill(unitId)

	-- Encerra imediatamente qualquer interação de mover/atacar sobre a unit
	-- morta, evitando que o PointingService continue disparando
	-- UnitPathfindingQuery após a morte.
	moveInput.stopIfUnit(unitId)
	attackInput.stopIfUnit(unitId)
end

return module
