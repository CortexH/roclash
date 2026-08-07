local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.unitCard.CardMoveButtonClick)
local moveSelectInput = require(root.input.MoveUnitInput)
local uiState = require(root.state.UIState)
local selectInput = require(root.input.SelectUnitInput)

function module.apply(event : eventType.CardMoveButtonClick)
    if event.data.btnSelected then onSelected(event.data.unitId) else onDeselected(event.data.unitId) end
end

function onSelected(unitId : string)
    moveSelectInput.beginSelect(unitId)
end

function onDeselected(unitId : string)
    moveSelectInput.stopSelect()
    if uiState.uiState.unitSelection.isSelectionButtonActivated then
        selectInput.beginSelect()
    end
end

return module
