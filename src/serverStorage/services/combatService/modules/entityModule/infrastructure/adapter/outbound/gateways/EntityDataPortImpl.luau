local module = {}

local port = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.gateways.UnitDataGatewayPort)

local structureConfigs = require(script.Parent.Parent.Parent.Parent.config.unitsConfigs.StructureUnitData)
local swordConfigs = require(script.Parent.Parent.Parent.Parent.config.unitsConfigs.UnitSwordData)

port.getStructureData = function(structureType : number)
	for _, build in structureConfigs do
		if build["structureType"] == structureType then
			return build
		end
	end
	
	return nil
end

port.getSwordData = function(swordType : number)
	for _, build in swordConfigs do
		if build["swordType"] == swordType then
			return build
		end
	end
	
	return nil
end


return module
