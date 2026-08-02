local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent

local cardController = require(root.ui.controllers.battleHudSubControllers.CardController)

-- Aplica um UI Diff recebido do servidor ao estado atualmente observado.
function module.apply(event)
	local selectedUnit = event.data.selectedUnit
	if not selectedUnit then return end

	cardController.updateSelectedUnitCard(selectedUnit)
end

return module
