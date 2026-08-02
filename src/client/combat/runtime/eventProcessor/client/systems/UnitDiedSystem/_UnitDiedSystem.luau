local module = {}

module.applies = {
	["UnitDied"] = require(script.Parent.ListenUnitDied).handle
}

return module
