local module = {}

module.applies = {
	["UnitPathfindingQuery"] = require(script.Parent.ListenUnitPathfindingQuery).handle
}

module.generates = {
}

return module
