local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.buttons.SelectInterfaceClientEvent)
local selectInput = require(root.input.SelectUnitInput)
local moveInput = require(root.input.MoveUnitInput)
local attackInput = require(root.input.AttackUnitInput)
local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)
local uiState = require(root.state.UIState)


function module.apply(event: eventType.SelectUnitButtonClicked)
	-- Ao clicar no botão select, encerra qualquer interação de mover/atacar em andamento
	-- e limpa a seleção atual, para começar do zero.
	moveInput.stopSelect()
	attackInput.stopSelect()
	selectInput.clearSelection()
	cardController.hideSelectedUnitCard()

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