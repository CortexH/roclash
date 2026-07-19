local module = {}

local API = require(game.ServerStorage.Server.services.combatService.API.activeBattles.ActiveBattlesAPI)

function module.handle(event, targetId)
	if(event.eventType ~= "GameBegin") then return end
	local context = API.getActiveBattle(targetId)
	if not context then return end
	--context["gameStateContext"] = "RUNNING"
end

return module
