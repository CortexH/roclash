local module = {}

module.applies = {
	["UnitPlacementCommandResponse"] = require(script.Parent.PlacementResponseApplier).apply
}

return module
