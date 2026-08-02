local module = {}

module.applies = {
	["UnitRemoved"] = require(script.Parent.ApplyUnitRemoved).apply
}

return module
