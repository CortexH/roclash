local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.buttons.SelectInterfaceClientEvent)
local selectInput = require(root.input.SelectUnitInput)
local uiState = require(root.state.UIState)


function module.apply(event: eventType.SelectUnitButtonClicked)
    if event.btnSelected then buttonSelect() else buttonDeselect() end
end

function buttonSelect()
    uiState.uiState.unitSelection.isSelectionButtonActivated = true
    selectInput.beginSelect()
end

function buttonDeselect()
    uiState.uiState.unitSelection.isSelectionButtonActivated = false
    selectInput.stopSelect()
end

return module