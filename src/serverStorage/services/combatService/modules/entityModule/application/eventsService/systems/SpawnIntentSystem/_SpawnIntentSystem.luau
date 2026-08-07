local module = {}

module.applies = {
	["SpawnIntent"] = require(script.Parent.ListenSpawnIntent).handle,
	["SpawnIntentAccepted"] = require(script.Parent.ListenSpawnIntentAccepted).handle
}

return module
