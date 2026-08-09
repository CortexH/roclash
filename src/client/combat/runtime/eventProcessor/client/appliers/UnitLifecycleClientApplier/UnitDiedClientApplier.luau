local module = {}

local states = script.Parent.Parent.Parent.Parent.Parent.Parent.state
local clientEvents = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.FrontEventTypes)

local viewRegistry = require(states.registry.UnitViewRegistry)
local stateCache = require(states.cache.UnitStateCache)
local definition = require(states.cache.UnitDefinitionCache)

local render = require(script.Parent.Parent.Parent.Parent.Parent.Parent.render.unit.UnitLifecycleRender)

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local moveInput = require(root.input.MoveUnitInput)
local attackInput = require(root.input.AttackUnitInput)
local selectInput = require(root.input.SelectUnitInput)
local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)

function module.apply(event : clientEvents.unitDied)
	local unitId = event.data.unitId

	local state = stateCache.get(unitId)

	state.placed = false
	state.health = 0
	state.maxHealth = 0
	state.owner = nil

	-- Encerra interações/seleções relacionadas à unit morta.
	moveInput.stopSelectIfUnit(unitId)
	attackInput.stopSelectIfUnit(unitId)
	selectInput.clearUnitSelection(unitId)
	cardController.hideSelectedUnitCardIfUnit(unitId)

	render.kill(unitId)
end

return module
