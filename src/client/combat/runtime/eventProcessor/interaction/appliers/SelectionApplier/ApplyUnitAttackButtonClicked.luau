local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.unitCard.CardAttackButtonClick)
local attackSelectInput = require(root.input.AttackUnitInput)
local uiState = require(root.state.UIState)
local selectInput = require(root.input.SelectUnitInput)

function module.apply(event : eventType.CardAttackButtonClick)
    if event.data.btnSelected then onSelected(event.data.unitId) else onDeselected(event.data.unitId) end
end

function onSelected(unitId : string)
    attackSelectInput.beginSelect(unitId)
end

function onDeselected(unitId : string)
    attackSelectInput.stopSelect()
    if uiState.uiState.unitSelection.isSelectionButtonActivated then
        selectInput.beginSelect()
    end
end

return module