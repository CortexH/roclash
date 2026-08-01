local module = {}

module.applies = {
	["SelectUnitButtonClickedClient"] = require(script.Parent.ListenSelectButtonClicked).listen
}

return module