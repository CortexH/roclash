local module = {}

module.applies = {
	["UnitSelectQuerySuccessResponse"] = require(script.Parent.ApplyUnitSelect).apply,
	["SelectUnitButtonClickedClient"] = require(script.Parent.ApplySelectButtonActive).apply,
	["CardAttackButtonClickedClient"] = require(script.Parent.ApplyUnitAttackButtonClicked).apply
}

return module