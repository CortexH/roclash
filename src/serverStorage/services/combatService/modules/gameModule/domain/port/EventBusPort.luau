local module = {}

local pathConsts = require(game.ServerStorage.Server.constants.CombatServiceModulesConsts)

local eventBusImpl = require(pathConsts.paths.gameModule.infrastructure.adapter.outbound.eventBus.EventBusPortImpl)

function module.subscribeEvent(event)
	eventBusImpl.sendEvent(event)
end

return module
