local module = {}

local port = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.MapsConstsPort)
local mapConfigs = require(game.ServerStorage.Server.services.combatService.modules.mapModule.infrastructure.config.MapConsts)

port.getMapDataConstsById = function(mapId : number)
	
	for _, v in mapConfigs do
		if v.mapId == mapId then
			return v
		end
	end
	
	return nil
	
end

return module
