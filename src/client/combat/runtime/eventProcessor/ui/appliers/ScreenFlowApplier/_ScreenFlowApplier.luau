local module = {}

module.applies = {
	["GameBeginEvent"] = require(script.Parent.ApplyGameBeginEvent).apply
}



return module