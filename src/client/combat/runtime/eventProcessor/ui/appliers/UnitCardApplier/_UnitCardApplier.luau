local module = {}

module.applies = {
	["UnitSelectQuerySuccessResponse"] = require(script.Parent.ApplyUnitSelect).apply,
	["SelectUnitButtonClickedClient"] = require(script.Parent.ApplySelectButtonActive).apply,
	["CardAttackButtonClickedClient"] = require(script.Parent.ApplyUnitAttackButtonClicked).apply,
	["CardMoveButtonClickedClient"] = require(script.Parent.ApplyUnitMoveButtonClicked).apply,
	["UIStateUpdateResponse"] = require(script.Parent.ApplyUIStateUpdate).apply
}

return module