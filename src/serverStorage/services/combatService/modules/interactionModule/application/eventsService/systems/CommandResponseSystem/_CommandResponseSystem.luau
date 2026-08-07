local module = {}

-- Gera commandResponses a partir dos intentResponses, quando a origem for o jogador.
module.applies = {
	["MoveIntentAccepted"] = require(script.Parent.ListenMoveIntentResponse).handle,
	["MoveIntentRejected"] = require(script.Parent.ListenMoveIntentResponse).handle,
	["SpawnIntentAccepted"] = require(script.Parent.ListenSpawnIntentResponse).handle,
	["SpawnIntentRejected"] = require(script.Parent.ListenSpawnIntentResponse).handle,
	["AggroIntentAccepted"] = require(script.Parent.ListenAggroIntentResponse).handle,
	["AggroIntentRejected"] = require(script.Parent.ListenAggroIntentResponse).handle
}

return module
