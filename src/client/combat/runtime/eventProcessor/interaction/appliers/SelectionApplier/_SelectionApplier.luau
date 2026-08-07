local module = {}

module.applies = {
	["SelectUnitButtonClickedClient"] = require(script.Parent.ApplySelectButtonClicked).apply,
    ["CardAttackButtonClickedClient"] = require(script.Parent.ApplyUnitAttackButtonClicked).apply,
    ["CardMoveButtonClickedClient"] = require(script.Parent.ApplyUnitMoveButtonClicked).apply
}

return module