local module = {}

-- IMPLEMENTS_MapModuleAPI

local api = require(game.ServerStorage.Server.services.combatService.API.mapModule.MapModuleAPI)
local cellService = require(game.ServerStorage.Server.services.combatService.modules.mapModule.application.services.CellService)
local positionService = require(script.Parent.Parent.Parent.Parent.Parent.application.services.PositionService)

-- PERFORMANCE: solução temporária, refazer mais tarde
api.isCellWalkable = function(cell, context)
	local unitsInCell = context["UnitsBC"]:getActiveUnitByCell(cell)
    for _, unit in pairs(unitsInCell) do
		if unit:isDead() then continue end
        local blockType = unit:getStructureConfig() and unit:getStructureConfig():getBlockCellType()
        if
        blockType == "ENTIRE_CELL"
        or blockType == "ONLY_CENTER"
        then
            return false
        end
    end
    return true
end

api.reserveCell = function(cell, context)
	cellService.reserveCell(cell, context)
end

api.unreserveCell = function(cell, context)
	cellService.unreserveCell(cell, context)
end

api.isCellReserved = function(cell, context)
	return cellService.isCellReserved(cell, context)
end

api.getCellByWorldPosition = function(req)
	return positionService.getCellByPosition({x = req.X, y = req.Y})
end

api.getWorldPositionByCell = function(request)
	return positionService.getPositionByCell({x = request.x, y = request.y})
end

return module
