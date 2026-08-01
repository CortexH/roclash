local module = {}

local battleHudScreen = require(script.Parent.Parent.Parent.screens.BattleHudScreen)
local interactionState = require(script.Parent.Parent.Parent.Parent.state.InteractionState)
local spawnUnitInput = require(script.Parent.Parent.Parent.Parent.input.SpawnUnitInput)

local view
local behaviorPanelVisible = false
local allVisible = false

function module.init(screen)
    view = screen
    allVisible = true
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

    if allVisible and behaviorPanelVisible then
        spawnUnitInput.beginSpawn()
    else
        spawnUnitInput.stopSpawn()
    end
end

function module.hideAll()
    allVisible = false
    view.placeUnitButton.Visible = false
    view.behaviorContainer.Visible = false
    spawnUnitInput.stopSpawn()
end

function module.showAll()
    allVisible = true
    view.placeUnitButton.Visible = true
    view.behaviorContainer.Visible = behaviorPanelVisible

    if behaviorPanelVisible then
       spawnUnitInput.beginSpawn()
    end
end

function onBehaviorSelected(behavior)
    interactionState.clientState.placementMode.currentBehavior = behavior
    battleHudScreen.setBehaviorSelected(view, behavior)
end


return module