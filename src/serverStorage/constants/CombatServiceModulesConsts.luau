local module = {}

module.paths = {
	["entityModule"] = game.ServerStorage.Server.services.combatService.modules.entityModule,
	["npcModule"] = game.ServerStorage.Server.services.combatService.modules.npcModule,
	["mapModule"] = game.ServerStorage.Server.services.combatService.modules.mapModule,
	["gameModule"] = game.ServerStorage.Server.services.combatService.modules.gameModule,
	["interactionModule"] = game.ServerStorage.Server.services.combatService.modules.interactionModule
}

return module
