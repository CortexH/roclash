local module = {}

local battleHudScreen = require(script.Parent.Parent.Parent.screens.BattleHudScreen)
local eventQueue = require(script.Parent.Parent.Parent.Parent.network.EnqueueEvent)
local eventType = require(script.Parent.Parent.Parent.Parent.events.buttons.SelectInterfaceClientEvent)
local PrimaryButton = require(script.Parent.Parent.Parent.Parent.Parent.assets.components.buttons.PrimaryButton)

type Screen = battleHudScreen.screen

local hudScreen : Screen = nil
local isButtonSelected = false

local selectButton = nil

function module.init(screen)
    hudScreen = screen
    selectButton = hudScreen.selectButton
    hudScreen.selectButton.Activated:Connect(onSelectClicked)
end

function module.destroy()
end

function onSelectClicked()
    isButtonSelected = not isButtonSelected
    eventQueue.enqueueEvent(generateSelectEvent())
    if isButtonSelected then
        PrimaryButton.setSelected(selectButton, true)
    else
        PrimaryButton.setSelected(selectButton, false)
    end
end

function generateSelectEvent() : eventType.SelectUnitButtonClicked
    return {
        delay = 0,
        eventType = "SelectUnitButtonClickedClient",
        btnSelected = isButtonSelected
    }
end

return module