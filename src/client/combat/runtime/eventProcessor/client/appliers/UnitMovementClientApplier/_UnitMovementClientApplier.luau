local module = {}

module.applies = {
	["UnitMove"] = require(script.Parent.UnitMoveClientApplier).apply
}

return module
