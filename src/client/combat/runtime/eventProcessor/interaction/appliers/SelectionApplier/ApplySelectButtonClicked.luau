local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.buttons.SelectInterfaceClientEvent)
local selectInput = require(root.input.SelectUnitInput)
local moveSelectInput = require(root.input.MoveUnitInput)
local attackSelectInput = require(root.input.AttackUnitInput)
local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)
local uiState = require(root.state.UIState)


function module.apply(event: eventType.SelectUnitButtonClicked)
    if event.btnSelected then buttonSelect() else buttonDeselect() end
end

function buttonSelect()
    uiState.uiState.unitSelection.isSelectionButtonActivated = true

    -- Ao ativar a seleção, encerra os modos de mover/atacar e reseta os
    -- toggles dos botões, garantindo exclusão mútua entre os modos.
    moveSelectInput.stopSelect()
    attackSelectInput.stopSelect()
    cardController.resetActionButtons()

    selectInput.beginSelect()
end

function buttonDeselect()
    uiState.uiState.unitSelection.isSelectionButtonActivated = false
    selectInput.stopSelect()
end

return module