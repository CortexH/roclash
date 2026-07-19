local module = {}

local battleHudScreen = require(script.Parent.Parent.screens.BattleHudScreen)
local interactionState = require(script.Parent.Parent.Parent.state.InteractionState)
local spawnUnitInput = require(script.Parent.Parent.Parent.input.SpawnUnitInput)

type Behavior = battleHudScreen.Behavior

local view: battleHudScreen.screen
local behaviorPanelVisible = false

function module.init(screen: battleHudScreen.screen)
    view = screen

    view.placeUnitButton.Activated:Connect(onPlaceUnitClicked)
    view.behaviorButtons.PEACEFUL.Activated:Connect(function()
        onBehaviorSelected("PEACEFUL")
    end)
    view.behaviorButtons.DEFENSIVE.Activated:Connect(function()
        onBehaviorSelected("DEFENSIVE")
    end)
    view.behaviorButtons.AGGRESSIVE.Activated:Connect(function()
        onBehaviorSelected("AGGRESSIVE")
    end)
end

function onPlaceUnitClicked()
    behaviorPanelVisible = not behaviorPanelVisible
    view.behaviorContainer.Visible = behaviorPanelVisible

    if behaviorPanelVisible then
        spawnUnitInput.beginSpawn()
    else
        spawnUnitInput.stopSpawn()
    end
end

function onBehaviorSelected(behavior: Behavior)
    interactionState.clientState.placementMode.currentBehavior = behavior
    battleHudScreen.setBehaviorSelected(view, behavior)
end

return module
