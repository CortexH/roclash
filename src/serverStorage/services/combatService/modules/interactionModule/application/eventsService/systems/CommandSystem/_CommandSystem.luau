local module = {}

-- Porta de entrada dos commands. Apenas traduz command -> intent, sem validação.
module.applies = {
	["UnitMoveCommand"] = require(script.Parent.ListenUnitMoveCommand).handle,
	["UnitPlacementCommand"] = require(script.Parent.ListenUnitPlacementCommand).handle,
	["UnitAggroCommand"] = require(script.Parent.ListenUnitAggroCommand).handle
}

return module
