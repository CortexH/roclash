local combatService = game.ServerStorage.Server.services.combatService

local modulesToLoad = {
    combatService.API.frontEnd.Remotes
}

for _, v in modulesToLoad do
    require(v)
end